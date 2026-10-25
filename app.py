from pathlib import Path

import pandas as pd
import plotly.express as px
import streamlit as st

st.set_page_config(
    page_title="E-Commerce Analytics Dashboard",
    page_icon="🛒",
    layout="wide",
)

PROJECT_DIR = Path(__file__).resolve().parent
OUTPUTS_DIR = PROJECT_DIR / "outputs"


@st.cache_data
def load_csv(file_path: str) -> pd.DataFrame:
    return pd.read_csv(file_path)


def read_output(file_name: str, required_columns: set[str]) -> pd.DataFrame:
    file_path = OUTPUTS_DIR / file_name

    if not file_path.exists():
        st.error(
            f"Couldn't find `{file_path.relative_to(PROJECT_DIR)}`. "
            "Make sure this dashboard is in the project root and the outputs folder exists."
        )
        st.stop()

    data = load_csv(str(file_path))
    missing_columns = required_columns.difference(data.columns)
    if missing_columns:
        st.error(
            f"`{file_name}` is missing expected columns: "
            + ", ".join(sorted(missing_columns))
        )
        st.stop()
    return data


kpis = read_output("executive_kpis.csv", {"metric", "value"})
monthly = read_output(
    "monthly_revenue.csv",
    {"order_month", "completed_orders", "monthly_revenue", "average_order_value"},
)
categories = read_output(
    "category_performance.csv",
    {"category", "units_sold", "category_revenue"},
)
products = read_output(
    "product_performance.csv",
    {"product_name", "category", "units_sold", "product_revenue"},
)

kpis["value"] = pd.to_numeric(kpis["value"], errors="coerce")
for column in ("completed_orders", "monthly_revenue", "average_order_value"):
    monthly[column] = pd.to_numeric(monthly[column], errors="coerce")
for column in ("units_sold", "category_revenue"):
    categories[column] = pd.to_numeric(categories[column], errors="coerce")
for column in ("units_sold", "product_revenue"):
    products[column] = pd.to_numeric(products[column], errors="coerce")

monthly["order_month"] = monthly["order_month"].astype(str)
monthly = monthly.sort_values("order_month")
categories = categories.sort_values("category_revenue", ascending=True)
products = products.sort_values("product_revenue", ascending=False)
kpi_values = dict(zip(kpis["metric"], kpis["value"]))


def get_kpi(metric_name: str) -> float:
    value = kpi_values.get(metric_name, 0)
    return float(value) if pd.notna(value) else 0.0


# Sidebar filters
st.sidebar.title("Dashboard filters")
st.sidebar.caption("These filters affect the charts and product table.")

month_options = monthly["order_month"].dropna().tolist()
if month_options:
    selected_month_range = st.sidebar.select_slider(
        "Monthly revenue period",
        options=month_options,
        value=(month_options[0], month_options[-1]),
    )
    start_month, end_month = selected_month_range
    monthly_filtered = monthly[monthly["order_month"].between(start_month, end_month)]
else:
    monthly_filtered = monthly

category_options = ["All categories"] + sorted(products["category"].dropna().unique().tolist())
selected_category = st.sidebar.selectbox("Product category", options=category_options)
if selected_category == "All categories":
    products_filtered = products.copy()
else:
    products_filtered = products[products["category"] == selected_category].copy()

# Header and KPI cards
st.title("🛒 E-Commerce Analytics Dashboard")
st.caption(
    "A business overview powered by your existing MySQL analysis exports. "
    "All financial values are in Indian rupees (INR)."
)

total_revenue = get_kpi("total_revenue")
completed_orders = get_kpi("completed_orders")
average_order_value = get_kpi("average_order_value")
repeat_purchase_rate = get_kpi("repeat_purchase_rate_percent")

col1, col2, col3, col4 = st.columns(4)
col1.metric("Total revenue", f"₹{total_revenue:,.0f}")
col2.metric("Completed orders", f"{completed_orders:,.0f}")
col3.metric("Average order value", f"₹{average_order_value:,.2f}")
col4.metric("Repeat purchase rate", f"{repeat_purchase_rate:.2f}%")

st.caption(
    "KPI cards show overall dataset totals. The month filter changes the monthly trend chart, "
    "while the category filter changes the product table."
)
st.divider()

# Monthly revenue trend
st.subheader("Monthly revenue trend")
if monthly_filtered.empty:
    st.info("There is no monthly revenue data for the selected period.")
else:
    revenue_chart = px.line(
        monthly_filtered,
        x="order_month",
        y="monthly_revenue",
        markers=True,
        custom_data=["completed_orders", "average_order_value"],
        labels={"order_month": "Month", "monthly_revenue": "Revenue (INR)"},
    )
    revenue_chart.update_traces(
        hovertemplate=(
            "<b>%{x}</b><br>Revenue: ₹%{y:,.2f}<br>"
            "Completed orders: %{customdata[0]:.0f}<br>"
            "Average order value: ₹%{customdata[1]:,.2f}<extra></extra>"
        )
    )
    revenue_chart.update_layout(
        height=380,
        margin=dict(l=10, r=10, t=25, b=10),
        yaxis_tickprefix="₹",
        yaxis_tickformat=",",
    )
    st.plotly_chart(revenue_chart, use_container_width=True)

st.divider()

# Category and product charts
left_col, right_col = st.columns(2)
with left_col:
    st.subheader("Revenue by category")
    category_chart = px.bar(
        categories,
        x="category_revenue",
        y="category",
        orientation="h",
        text="category_revenue",
        labels={"category_revenue": "Revenue (INR)", "category": "Category"},
    )
    category_chart.update_traces(
        texttemplate="₹%{x:,.0f}",
        textposition="outside",
        cliponaxis=False,
        hovertemplate="%{y}<br>Revenue: ₹%{x:,.2f}<extra></extra>",
    )
    category_chart.update_layout(
        height=350,
        margin=dict(l=10, r=45, t=20, b=10),
        xaxis_tickprefix="₹",
        xaxis_tickformat=",",
    )
    st.plotly_chart(category_chart, use_container_width=True)

with right_col:
    st.subheader("Top products by revenue")
    top_products = products.head(6).sort_values("product_revenue", ascending=True)
    product_chart = px.bar(
        top_products,
        x="product_revenue",
        y="product_name",
        orientation="h",
        text="product_revenue",
        labels={"product_revenue": "Revenue (INR)", "product_name": "Product"},
    )
    product_chart.update_traces(
        texttemplate="₹%{x:,.0f}",
        textposition="outside",
        cliponaxis=False,
        hovertemplate="%{y}<br>Revenue: ₹%{x:,.2f}<extra></extra>",
    )
    product_chart.update_layout(
        height=350,
        margin=dict(l=10, r=45, t=20, b=10),
        xaxis_tickprefix="₹",
        xaxis_tickformat=",",
    )
    st.plotly_chart(product_chart, use_container_width=True)

st.divider()

# Product table
st.subheader("Product performance")
st.write(
    "Use the category filter in the sidebar to narrow this table. "
    "Products are sorted by revenue, highest first."
)
if products_filtered.empty:
    st.info("No products match the selected category.")
else:
    product_table = products_filtered[
        ["product_name", "category", "units_sold", "product_revenue"]
    ].copy()
    product_table = product_table.rename(
        columns={
            "product_name": "Product",
            "category": "Category",
            "units_sold": "Units sold",
            "product_revenue": "Revenue (INR)",
        }
    )
    product_table["Revenue (INR)"] = product_table["Revenue (INR)"].map(
        lambda value: f"₹{value:,.2f}" if pd.notna(value) else "N/A"
    )
    st.dataframe(product_table, use_container_width=True, hide_index=True)

st.caption(
    "Data source: outputs/*.csv in this repository. The dataset is synthetic, "
    "and only COMPLETED orders contribute to recognized revenue in the SQL analysis."
)
