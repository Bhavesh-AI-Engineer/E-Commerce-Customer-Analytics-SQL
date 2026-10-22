#!/usr/bin/env python3
"""Validate the e-commerce CSV dataset and exported analysis outputs.

Uses only the Python standard library.
Run from the repository root:

    python validate_data.py
"""

from __future__ import annotations

import csv
import sys
from collections import defaultdict
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT / "data"
OUTPUT_DIR = ROOT / "outputs"

REQUIRED_DATA_FILES = {
    "customers.csv": ["customer_id", "customer_name", "city", "signup_date"],
    "products.csv": ["product_id", "product_name", "category", "list_price"],
    "orders.csv": ["order_id", "customer_id", "order_date", "order_status"],
    "order_items.csv": [
        "order_item_id",
        "order_id",
        "product_id",
        "quantity",
        "unit_price",
        "discount_percent",
    ],
}

REQUIRED_OUTPUT_FILES = {
    "executive_kpis.csv",
    "monthly_revenue.csv",
    "product_performance.csv",
    "category_performance.csv",
}

ALLOWED_STATUSES = {"COMPLETED", "CANCELLED", "PENDING"}
TWOPLACES = Decimal("0.01")


def money(value: Decimal) -> Decimal:
    return value.quantize(TWOPLACES, rounding=ROUND_HALF_UP)


def load_csv(path: Path) -> tuple[list[str], list[dict[str, str]]]:
    with path.open("r", newline="", encoding="utf-8-sig") as file:
        reader = csv.DictReader(file)
        rows = list(reader)
        return reader.fieldnames or [], rows


def check(condition: bool, message: str, errors: list[str]) -> None:
    if condition:
        print(f"[PASS] {message}")
    else:
        print(f"[FAIL] {message}")
        errors.append(message)


def unique_ids(rows: list[dict[str, str]], field: str) -> bool:
    values = [row[field] for row in rows]
    return len(values) == len(set(values))


def main() -> int:
    errors: list[str] = []

    print("\nE-Commerce Analytics Validation")
    print("=" * 32)

    # 1. Required files and schemas
    datasets: dict[str, list[dict[str, str]]] = {}

    for filename, expected_header in REQUIRED_DATA_FILES.items():
        path = DATA_DIR / filename
        check(path.exists(), f"{path.relative_to(ROOT)} exists", errors)
        if not path.exists():
            continue

        header, rows = load_csv(path)
        check(header == expected_header, f"{filename} has the expected columns", errors)
        check(len(rows) > 0, f"{filename} contains data", errors)
        datasets[filename] = rows

    for filename in REQUIRED_OUTPUT_FILES:
        check((OUTPUT_DIR / filename).exists(), f"outputs/{filename} exists", errors)

    if any(name not in datasets for name in REQUIRED_DATA_FILES):
        print("\nValidation stopped because required dataset files are missing.")
        return 1

    customers = datasets["customers.csv"]
    products = datasets["products.csv"]
    orders = datasets["orders.csv"]
    items = datasets["order_items.csv"]

    print("\nDataset integrity")
    print("-" * 32)

    # 2. Primary-key uniqueness
    check(unique_ids(customers, "customer_id"), "customer_id values are unique", errors)
    check(unique_ids(products, "product_id"), "product_id values are unique", errors)
    check(unique_ids(orders, "order_id"), "order_id values are unique", errors)
    check(unique_ids(items, "order_item_id"), "order_item_id values are unique", errors)

    customer_ids = {row["customer_id"] for row in customers}
    product_ids = {row["product_id"] for row in products}
    order_ids = {row["order_id"] for row in orders}

    # 3. Foreign-key integrity
    check(
        all(row["customer_id"] in customer_ids for row in orders),
        "every order references an existing customer",
        errors,
    )
    check(
        all(row["order_id"] in order_ids for row in items),
        "every order item references an existing order",
        errors,
    )
    check(
        all(row["product_id"] in product_ids for row in items),
        "every order item references an existing product",
        errors,
    )

    # 4. Business-rule validation
    check(
        all(row["order_status"] in ALLOWED_STATUSES for row in orders),
        "all order statuses are valid",
        errors,
    )
    check(
        all(int(row["quantity"]) > 0 for row in items),
        "all quantities are positive",
        errors,
    )
    check(
        all(Decimal(row["unit_price"]) > 0 for row in items),
        "all unit prices are positive",
        errors,
    )
    check(
        all(Decimal("0") <= Decimal(row["discount_percent"]) <= Decimal("100") for row in items),
        "all discounts are between 0 and 100",
        errors,
    )

    print("\nOutput reconciliation")
    print("-" * 32)

    order_by_id = {row["order_id"]: row for row in orders}
    product_by_id = {row["product_id"]: row for row in products}

    completed_orders = {
        row["order_id"]: row
        for row in orders
        if row["order_status"] == "COMPLETED"
    }

    order_revenue: dict[str, Decimal] = defaultdict(lambda: Decimal("0"))
    product_units: dict[str, int] = defaultdict(int)
    product_revenue: dict[str, Decimal] = defaultdict(lambda: Decimal("0"))
    category_units: dict[str, int] = defaultdict(int)
    category_revenue: dict[str, Decimal] = defaultdict(lambda: Decimal("0"))

    for item in items:
        if item["order_id"] not in completed_orders:
            continue

        quantity = int(item["quantity"])
        unit_price = Decimal(item["unit_price"])
        discount = Decimal(item["discount_percent"])

        line_revenue = (
            Decimal(quantity)
            * unit_price
            * (Decimal("1") - discount / Decimal("100"))
        )

        order_revenue[item["order_id"]] += line_revenue

        product_id = item["product_id"]
        product = product_by_id[product_id]
        category = product["category"]

        product_units[product_id] += quantity
        product_revenue[product_id] += line_revenue
        category_units[category] += quantity
        category_revenue[category] += line_revenue

    total_revenue = money(sum(order_revenue.values(), Decimal("0")))
    completed_order_count = len(completed_orders)
    purchasing_customers = {
        order["customer_id"] for order in completed_orders.values()
    }

    customer_completed_orders: dict[str, int] = defaultdict(int)
    for order in completed_orders.values():
        customer_completed_orders[order["customer_id"]] += 1

    repeat_customers = sum(
        1 for count in customer_completed_orders.values() if count >= 2
    )

    repeat_rate = money(
        Decimal(repeat_customers)
        / Decimal(len(purchasing_customers))
        * Decimal("100")
    )
    average_order_value = money(
        total_revenue / Decimal(completed_order_count)
    )

    # Executive KPI reconciliation
    executive_path = OUTPUT_DIR / "executive_kpis.csv"
    if executive_path.exists():
        _, executive_rows = load_csv(executive_path)
        executive = {row["metric"]: row["value"] for row in executive_rows}

        expected_kpis = {
            "total_customers": str(len(customers)),
            "purchasing_customers": str(len(purchasing_customers)),
            "completed_orders": str(completed_order_count),
            "total_revenue": f"{total_revenue:.2f}",
            "average_order_value": f"{average_order_value:.2f}",
            "repeat_customers": str(repeat_customers),
            "repeat_purchase_rate_percent": f"{repeat_rate:.2f}",
        }

        for metric, expected in expected_kpis.items():
            actual = executive.get(metric)
            if metric in {
                "total_revenue",
                "average_order_value",
                "repeat_purchase_rate_percent",
            } and actual is not None:
                try:
                    actual = f"{Decimal(actual):.2f}"
                except Exception:
                    pass
            check(
                actual == expected,
                f"executive KPI {metric} reconciles ({expected})",
                errors,
            )

    # Monthly revenue reconciliation
    monthly_path = OUTPUT_DIR / "monthly_revenue.csv"
    if monthly_path.exists():
        _, monthly_rows = load_csv(monthly_path)

        expected_monthly: dict[str, dict[str, Decimal | int]] = {}
        monthly_order_ids: dict[str, list[str]] = defaultdict(list)

        for order_id, order in completed_orders.items():
            month = order["order_date"][:7]
            monthly_order_ids[month].append(order_id)

        for month, ids in monthly_order_ids.items():
            revenue = money(sum((order_revenue[i] for i in ids), Decimal("0")))
            count = len(ids)
            expected_monthly[month] = {
                "completed_orders": count,
                "monthly_revenue": revenue,
                "average_order_value": money(revenue / Decimal(count)),
            }

        actual_months = {row["order_month"] for row in monthly_rows}
        check(
            actual_months == set(expected_monthly),
            "monthly_revenue.csv contains the expected months",
            errors,
        )

        for row in monthly_rows:
            month = row["order_month"]
            if month not in expected_monthly:
                continue
            expected = expected_monthly[month]
            check(
                int(row["completed_orders"]) == expected["completed_orders"]
                and money(Decimal(row["monthly_revenue"])) == expected["monthly_revenue"]
                and money(Decimal(row["average_order_value"])) == expected["average_order_value"],
                f"{month} monthly output reconciles",
                errors,
            )

    # Product performance reconciliation
    product_path = OUTPUT_DIR / "product_performance.csv"
    if product_path.exists():
        _, product_rows = load_csv(product_path)
        actual_products = {row["product_id"]: row for row in product_rows}
        check(
            set(actual_products) == set(product_units),
            "product_performance.csv contains all sold products",
            errors,
        )

        for product_id, units in product_units.items():
            row = actual_products.get(product_id)
            if row is None:
                continue
            product = product_by_id[product_id]
            check(
                row["product_name"] == product["product_name"]
                and row["category"] == product["category"]
                and int(row["units_sold"]) == units
                and money(Decimal(row["product_revenue"])) == money(product_revenue[product_id]),
                f"product {product_id} output reconciles",
                errors,
            )

    # Category performance reconciliation
    category_path = OUTPUT_DIR / "category_performance.csv"
    if category_path.exists():
        _, category_rows = load_csv(category_path)
        actual_categories = {row["category"]: row for row in category_rows}
        check(
            set(actual_categories) == set(category_units),
            "category_performance.csv contains all sold categories",
            errors,
        )

        for category, units in category_units.items():
            row = actual_categories.get(category)
            if row is None:
                continue
            check(
                int(row["units_sold"]) == units
                and money(Decimal(row["category_revenue"])) == money(category_revenue[category]),
                f"{category} category output reconciles",
                errors,
            )

    print("\n" + "=" * 32)
    if errors:
        print(f"VALIDATION FAILED: {len(errors)} check(s) failed.")
        return 1

    print("VALIDATION PASSED: all checks succeeded.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
