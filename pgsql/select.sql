SELECT 'week' as period_type,
				week_dt::DATE as start_date, 
				week_dt_end::DATE as end_date, 
				salesman_fio, 
				fio as chif_fio, 
				quant as sales_count, 
				total_price as sales_sum,  
				max_proc as max_overcharge_percent 
FROM
	(SELECT (week_dt + interval '7 day') as week_dt_end, 
	* FROM
		(SELECT * 
		FROM
			(SELECT week_dt, 
							quant, 
							max as max_proc, 
							total_price, 
							fio as salesman_fio, 
							department_id 
				FROM
				(SELECT DATE_TRUNC('week', sale_date) as week_dt,
								salesman_id,
								sum(quantity) as quant, 
								max(extra_charge), 
								sum(final_price) as total_price
				FROM 
					(SELECT *, 
									round(CAST( float8 ((((final_price::float / quantity) / shop_price) - 1) * 100) AS NUMERIC),  3) as extra_charge
					FROM
						(SELECT s.sale_date as sale_date, 
										s.salesman_id as salesman_id, 
										s.item_id as item_id, 
										s.quantity as quantity, 
										s.final_price as final_price, 
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
						order by s.sale_date) as shop_price_table
					) as pre_result_table
				GROUP BY DATE_TRUNC('week', sale_date), salesman_id
				order by week_dt) as result1
			LEFT JOIN
			(select maindf.salesman, df1.fio, df1.department_id
			FROM(
			SELECT salesman_id as salesman
			FROM shikhaldin.sales maindf
			GROUP BY salesman
			)as maindf
			LEFT JOIN shikhaldin.sellers df1 on maindf.salesman = df1.id) as sman on sman.salesman = result1.salesman_id) as result2
		LEFT JOIN shikhaldin.departments df2 on result2.department_id = df2.department_id) as result3
	LEFT JOIN shikhaldin.sellers df3 on result3.dep_chif_id = df3.id
	ORDER BY week_dt)
as res
WHERE not (salesman_fio is null)
order by start_date