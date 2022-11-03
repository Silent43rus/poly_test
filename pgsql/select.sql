-- SELECT period_type,
-- 			 start_date,
-- 			 end_date,
-- 			 salesman_fio,
-- 			 chif_fio,
-- 			 sales_count,
-- 			 sales_sum,
-- 			 max_overcharge_item,
-- 			 max_overcharge_percent,

-- SELECT DATE_TRUNC('week', sale_date) as month_dt,
-- 	salesman_id,
-- 	count(quantity) as quant
-- FROM shikhaldin.sales
-- GROUP BY DATE_TRUNC('week', sale_date), salesman_id
-- order by month_dt

-- select df1.fio, maindf.quant, maindf.price
-- FROM(
-- SELECT salesman_id as salesman ,sum(quantity) as quant, sum(final_price) as price
-- FROM shikhaldin.sales
-- GROUP BY salesman
-- )as maindf
-- LEFT JOIN shikhaldin.sellers df1 on maindf.salesman = df1.id

-- SELECT df1.fio, fio
-- FROM shikhaldin.sales
-- LEFT JOIN shikhaldin.sellers df1 on salesman_id = id
-- (shop_price /(final_price / quantity))

SELECT DATE_TRUNC('week', sale_date) as week_dt,
	salesman_id,
	sum(quantity) as quant, max(extra_charge), sum(final_price) as total_price, max(CHAR_LENGTH(item_id)) as item
FROM 
(SELECT *, round(CAST( float8 ((((final_price::float / quantity) / shop_price) - 1) * 100) AS NUMERIC),  3) as extra_charge
FROM(
SELECT s.sale_date as sale_date, s.salesman_id as salesman_id, s.item_id as item_id, s.quantity as quantity, s.final_price as final_price, 
				(CASE WHEN
							p.price is null
							THEN ser.price
							WHEN
							ser.price is null
							THEN p.price 
							END) as shop_price
FROM shikhaldin.sales s
LEFT JOIN shikhaldin.products p on (s.item_id = p.id) and ((s.sale_date > p.sdate) and (s.sale_date < p.edate))
LEFT JOIN shikhaldin.services ser on (s.item_id = ser.id) and ((s.sale_date > ser.sdate) and (s.sale_date < ser.edate))
order by s.sale_date
) as shop_price_table) 
as pre_result_table
GROUP BY DATE_TRUNC('week', sale_date), salesman_id
order by week_dt