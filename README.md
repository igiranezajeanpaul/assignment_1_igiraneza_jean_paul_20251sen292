# PLSQL Assignment One Sunrise Supermarket

## Student Information

- **Name:** IGIRANEZA JEAN PAUL
- **Student ID:** 20251SEN292
- **Group:** I
- **DBMS:** PostgreSQL
- **Repository:** `assignment_1_igiraneza_jean_paul_20251sen292`

## Business Scenario

Sunrise Supermarket sells products to customers who place orders containing one or more items. Management wants to understand who its customers are, what they purchase, and how sales change over time.

This project uses fictional Rwandan customer information and sample product prices in Rwandan francs (RWF). SQL JOINs, Common Table Expressions (CTEs), and window functions are used to analyse customer purchases and revenue.

## Work Completed

The database contains four related tables:

| Table | Purpose | Records |
|---|---|---:|
| customers | Stores customer names, emails, and cities | 6 |
| products | Stores product names, categories, and prices | 8 |
| orders | Records customers’ orders and order dates | 15 |
| order_items | Records products and quantities within orders | 30 |

The products belong to four categories: Grains and Legumes, Fresh Produce, Dairy, and Beverages. Orders cover January to March 2026.

One customer has no orders, allowing the LEFT JOIN query to demonstrate how customers without purchases remain visible.

## How to Run

Open the database in pgAdmin and execute the scripts in the Query Tool in the same order. Run the table creation and data insertion scripts once in an empty database to avoid duplicate-table and primary-key errors.

## JOIN Queries

### 1. Orders with Customer Details

**Purpose:** List every order with the customer’s name, city, and order date.

```sql
SELECT o.order_id, c.customer_name, c.city, o.order_date FROM orders o INNER JOIN customers c ON o.customer_id = c.customer_id ORDER BY o.order_date, o.order_id;
```

**Explanation:** The INNER JOIN connects orders to customers using `customer_id`. It returns orders that have a matching customer.

**Result:**

<img width="1670" height="410" alt="Q1" src="https://github.com/user-attachments/assets/4f4850fc-124c-4cee-861c-93373494aa6d" />


**Business interpretation:** The result connects each purchase to a customer and city. Management can use this information to investigate where purchasing customers are located.

### 2. Order Items with Product Details

**Purpose:** Show the product name, category, unit price, and quantity for every order item.

```sql
SELECT oi.order_item_id, oi.order_id, p.product_name, p.category, p.price, oi.quantity FROM order_items oi INNER JOIN products p ON oi.product_id = p.product_id ORDER BY oi.order_id, oi.order_item_id;
```

**Explanation:** The JOIN connects `order_items` to `products` using `product_id`. Each result row represents one product line within an order.

**Result:**

<img width="1917" height="706" alt="Q2" src="https://github.com/user-attachments/assets/cbca59b9-ef7d-44bb-b171-feddd9b5e68e" />


**Business interpretation:** Management can see which products were purchased and in what quantities. This provides the detail needed for further analysis of product demand and stock requirements.

### 3. All Customers, Including Those Without Orders

**Purpose:** List every customer and their orders where available.

```sql
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id ORDER BY c.customer_id, o.order_date, o.order_id;
```

**Explanation:** The LEFT JOIN preserves every customer, even when no matching order exists. Customers without orders have `NULL` values in the order columns.

**Result:**

<img width="1912" height="403" alt="Q3" src="https://github.com/user-attachments/assets/0f12c0e5-442f-4877-a4c9-d5e22deb5147" />


**Business interpretation:** Claudine Uwera appears without an order. This helps management identify registered customers who have not yet purchased and consider suitable first-purchase promotions.

## CTE Query

### 4. Customers with Above-Average Spending

**Purpose:** Calculate each customer’s total spending and return customers whose spending exceeds the average.

```sql
WITH customer_totals AS (SELECT c.customer_id, c.customer_name, COALESCE(SUM(oi.quantity * p.price), 0) AS total_spend FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id LEFT JOIN order_items oi ON o.order_id = oi.order_id LEFT JOIN products p ON oi.product_id = p.product_id GROUP BY c.customer_id, c.customer_name) SELECT customer_id, customer_name, total_spend FROM customer_totals WHERE total_spend > (SELECT AVG(total_spend) FROM customer_totals) ORDER BY total_spend DESC, customer_id;
```

**Explanation:** The `customer_totals` CTE calculates total spending using `quantity × price`. LEFT JOINs preserve customers without orders, while `COALESCE` assigns them zero spending. The main query compares each total against the average across all six customers.

**Result:**

<img width="1917" height="205" alt="Q4" src="https://github.com/user-attachments/assets/dcede733-e877-4dd5-a040-7a99e8b95147" />


**Business interpretation:** Jean Paul Igiraneza, Aline Uwase, Eric Niyonzima, and Patrick Mugisha spend above the average of approximately RWF 20,966.67. Management could consider these customers for loyalty programmes.

## Window-Function Queries

### 5. Rank Customers by Total Spending

**Purpose:** Rank customers from highest to lowest total spending.

```sql
WITH customer_totals AS (SELECT c.customer_id, c.customer_name, COALESCE(SUM(oi.quantity * p.price), 0) AS total_spend FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id LEFT JOIN order_items oi ON o.order_id = oi.order_id LEFT JOIN products p ON oi.product_id = p.product_id GROUP BY c.customer_id, c.customer_name) SELECT customer_id, customer_name, total_spend, RANK() OVER (ORDER BY total_spend DESC) AS spending_rank FROM customer_totals ORDER BY spending_rank, customer_id;
```

**Explanation:** The CTE calculates customer totals. `RANK()` assigns rank 1 to the highest spender. Customers with equal totals receive the same rank, with a gap before the next rank.

**Result:**

<img width="1917" height="252" alt="Q5" src="https://github.com/user-attachments/assets/541c3444-a53d-4263-b1c5-f502c8c3850a" />


**Business interpretation:** Jean Paul Igiraneza ranks first with RWF 43,000 in spending. Ranking helps management identify its highest-spending customers and plan customer retention activities.

### 6. Number Each Customer’s Orders

**Purpose:** Assign a chronological order number to each customer’s purchases.

```sql
SELECT customer_id, order_id, order_date, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date, order_id) AS customer_order_number FROM orders ORDER BY customer_id, order_date, order_id;
```

**Explanation:** `PARTITION BY customer_id` creates a separate sequence for each customer. `ROW_NUMBER()` numbers their orders by date, starting at 1. The order ID breaks ties when dates are equal.

**Result:**

<img width="1917" height="417" alt="Q6" src="https://github.com/user-attachments/assets/938f8d23-7eb2-4e53-87ba-050e8e89610a" />


**Business interpretation:** Jean Paul Igiraneza has four orders; Aline Uwase, Eric Niyonzima, and Patrick Mugisha each have three; Diane Mukamana has two. This helps management distinguish first purchases from repeat purchases.

### 7. Running Revenue over Time

**Purpose:** Show daily revenue and the cumulative revenue earned up to each sales date.

```sql
WITH daily_revenue AS (SELECT o.order_date, SUM(oi.quantity * p.price) AS revenue FROM orders o INNER JOIN order_items oi ON o.order_id = oi.order_id INNER JOIN products p ON oi.product_id = p.product_id GROUP BY o.order_date) SELECT order_date, revenue AS daily_revenue, SUM(revenue) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_revenue FROM daily_revenue ORDER BY order_date;
```

**Explanation:** The CTE groups item revenue by order date. The window function adds revenue from the first sales date through the current row. Dates without sales are not displayed.

**Result:**

<img width="1917" height="431" alt="Q7" src="https://github.com/user-attachments/assets/fdaa7240-ab73-4c9c-aaf4-ab046dd924c7" />


**Business interpretation:** Cumulative revenue reaches RWF 125,800 by March 29, 2026. Adding the daily revenue within each month gives RWF 21,900 for January, RWF 37,500 for February, and RWF 66,400 for March. Monthly revenue increases in this sample.

### 8. Days between Orders for Repeat Customers

**Purpose:** Show the number of days between consecutive purchases for customers who have more than one order.

```sql
WITH order_history AS (SELECT customer_id, order_id, order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date, order_id) AS previous_order_date, COUNT(*) OVER (PARTITION BY customer_id) AS order_count FROM orders) SELECT customer_id, order_id, order_date, previous_order_date, order_date - previous_order_date AS days_since_previous FROM order_history WHERE order_count > 1 ORDER BY customer_id, order_date, order_id;
```

**Explanation:** `LAG()` retrieves each customer’s previous order date. `COUNT()` identifies customers with multiple orders. PostgreSQL returns the number of days when one `DATE` is subtracted from another. A customer’s first order has a `NULL` gap because there is no previous order.

**Result:**

<img width="1917" height="428" alt="Q8" src="https://github.com/user-attachments/assets/bace26e9-78ab-4888-84f1-638acd2f56e8" />


**Business interpretation:** The result shows how long customers wait before purchasing again. For example, Jean Paul Igiraneza’s gaps are 30, 30, and 25 days. These intervals could help management investigate purchasing frequency and the timing of customer reminders.

## Overall Business Interpretation

The sample data shows total revenue of **RWF 125,800** from **15 orders**, giving an average order value of approximately **RWF 8,386.67**.

Monthly revenue increases even though each month contains five orders. This means the increase comes from the quantities and value of products purchased rather than an increase in the number of orders.

Five customers made repeat purchases, while one registered customer made none. Management could use these findings to explore loyalty offers for returning customers and introductory promotions for customers who have not purchased.

These findings describe a small fictional dataset and should not be treated as evidence of actual supermarket performance.

## Challenges and Resolutions

### Adapting the Schema to PostgreSQL

The supplied schema used Oracle data types. `NUMBER` was replaced with `INTEGER` for IDs and quantities, `NUMBER(10,2)` with `NUMERIC(10,2)` for prices, and `VARCHAR2` with `VARCHAR`.

### Including Customers Without Orders

INNER JOINs would exclude customers without purchases. LEFT JOINs were used to preserve them, and `COALESCE` converted missing spending totals to zero.

### Avoiding Duplicate Calculations

Joining orders to order items produces multiple rows per order. Customer spending and daily revenue were aggregated before applying ranking or cumulative calculations. Order numbering and purchase gaps were calculated directly from the orders table.

### Handling First Orders and Matching Dates

A customer’s first order has no previous order, so its purchase gap remains `NULL`. Ordering by both `order_date` and `order_id` makes order numbering and previous-order selection consistent when dates match.

### Defining Average Spending

Average spending was calculated across all registered customers, including the customer with zero purchases. This definition was used consistently in the above-average query.
