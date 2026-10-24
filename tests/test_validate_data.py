import contextlib
import csv
import importlib.util
import io
import shutil
import tempfile
import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
VALIDATOR_PATH = REPO_ROOT / "scripts" / "validate_data.py"


def load_validator():
    spec = importlib.util.spec_from_file_location("validate_data", VALIDATOR_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


class TestDataValidator(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.project_root = Path(self.temp_dir.name)

        shutil.copytree(REPO_ROOT / "data", self.project_root / "data")
        shutil.copytree(REPO_ROOT / "outputs", self.project_root / "outputs")

        self.validator = load_validator()
        self.validator.ROOT = self.project_root
        self.validator.DATA_DIR = self.project_root / "data"
        self.validator.OUTPUT_DIR = self.project_root / "outputs"

    def tearDown(self):
        self.temp_dir.cleanup()

    def run_validator(self):
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            exit_code = self.validator.main()
        return exit_code, output.getvalue()

    def test_current_project_data_passes(self):
        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 0)
        self.assertIn("VALIDATION PASSED", output)

    def test_duplicate_customer_id_is_detected(self):
        path = self.project_root / "data" / "customers.csv"

        with path.open("r", newline="", encoding="utf-8") as file:
            rows = list(csv.reader(file))

        rows.append(rows[1])

        with path.open("w", newline="", encoding="utf-8") as file:
            csv.writer(file).writerows(rows)

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("[FAIL] customer_id values are unique", output)

    def test_broken_customer_foreign_key_is_detected(self):
        path = self.project_root / "data" / "orders.csv"

        with path.open("r", newline="", encoding="utf-8") as file:
            rows = list(csv.DictReader(file))
            fieldnames = ["order_id", "customer_id", "order_date", "order_status"]

        rows[0]["customer_id"] = "999999"

        with path.open("w", newline="", encoding="utf-8") as file:
            writer = csv.DictWriter(file, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rows)

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn(
            "[FAIL] every order references an existing customer",
            output,
        )

    def test_invalid_discount_is_detected(self):
        path = self.project_root / "data" / "order_items.csv"

        with path.open("r", newline="", encoding="utf-8") as file:
            rows = list(csv.DictReader(file))
            fieldnames = [
                "order_item_id",
                "order_id",
                "product_id",
                "quantity",
                "unit_price",
                "discount_percent",
            ]

        rows[0]["discount_percent"] = "150"

        with path.open("w", newline="", encoding="utf-8") as file:
            writer = csv.DictWriter(file, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rows)

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("[FAIL] all discounts are between 0 and 100", output)


    def test_invalid_order_status_is_detected(self):
        path = self.project_root / "data" / "orders.csv"

        with path.open("r", newline="", encoding="utf-8") as file:
            rows = list(csv.DictReader(file))
            fieldnames = ["order_id", "customer_id", "order_date", "order_status"]

        rows[0]["order_status"] = "SHIPPED"

        with path.open("w", newline="", encoding="utf-8") as file:
            writer = csv.DictWriter(file, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rows)

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("[FAIL] all order statuses are valid", output)

    def test_zero_quantity_is_detected(self):
        path = self.project_root / "data" / "order_items.csv"

        with path.open("r", newline="", encoding="utf-8") as file:
            rows = list(csv.DictReader(file))
            fieldnames = [
                "order_item_id",
                "order_id",
                "product_id",
                "quantity",
                "unit_price",
                "discount_percent",
            ]

        rows[0]["quantity"] = "0"

        with path.open("w", newline="", encoding="utf-8") as file:
            writer = csv.DictWriter(file, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rows)

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("[FAIL] all quantities are positive", output)

    def test_incorrect_revenue_kpi_is_detected(self):
        path = self.project_root / "outputs" / "executive_kpis.csv"

        with path.open("r", newline="", encoding="utf-8") as file:
            rows = list(csv.DictReader(file))
            fieldnames = ["metric", "value"]

        for row in rows:
            if row["metric"] == "total_revenue":
                row["value"] = "999999.00"
                break
        else:
            self.fail("total_revenue KPI was not found in executive_kpis.csv")

        with path.open("w", newline="", encoding="utf-8") as file:
            writer = csv.DictWriter(file, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rows)

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("[FAIL] executive KPI total_revenue reconciles", output)


if __name__ == "__main__":
    unittest.main()
