CREATE OR REPLACE TABLE etl-bde3.etl_bde3_data.tbl_analytics AS (
SELECT
od.order_detail_id,
od.order_id,
od.product_id,
od.quantity,
od.subtotal,
c.customer_id,
c.first_name,
c.last_name,
c.date_joined,
o.date AS order_date,
o.total_amount,
o.shipping_address,
p.product_name,
p.category,
p.price,
p.stock_quantity

FROM etl-bde3.etl_bde3_data.OrderDetails od
JOIN etl-bde3.etl_bde3_data.Orders o ON od.order_id=o.order_id
JOIN etl-bde3.etl_bde3_data.Customers c ON o.customer_id=c.customer_id
JOIN etl-bde3.etl_bde3_data.Products p ON od.product_id= p.product_id);