/* Formatted on 2021/07/26 11:48 (Formatter Plus v4.8.8) */
SELECT   haou.NAME bg_name, hou.NAME org_name, aia.invoice_num,
         aia.invoice_amount, aia.invoice_date, aia.creation_date, a.*,
         TO_CHAR (SYSDATE, 'DD-Mon-RRRR hh12:mi:ss AM') export_date,
         (SELECT instance_name
            FROM v$instance) AS instance_name
    FROM (SELECT   ROW_NUMBER () OVER (PARTITION BY invoice_id ORDER BY DECODE
                                                                   (iteration,
                                                                    0, 9999,
                                                                    iteration
                                                                   ),
                    DECODE (line_number, NULL, 9999, line_number),
                    last_update_date,
                    approver_order_number) sequence_num,
                   approval_context_dsp, last_update_date, line_number,
                   response_dsp, approver_name, amount_approved,
                   approver_comments, invoice_id, response, approval_context,
                   person_id, approver_order_number
              FROM ap_wfapproval_history_v
             WHERE 1 = 1
               AND ('' IS NULL OR ('' IS NOT NULL AND line_number = ''))
          ORDER BY DECODE (iteration, 0, 9999, iteration),
                   DECODE (line_number, NULL, 9999, line_number),
                   last_update_date,
                   approver_order_number) a,
         ap_invoices_all aia,
         hr_operating_units hou,
         hr_all_organization_units haou
   WHERE hou.organization_id = aia.org_id
     AND hou.business_group_id = haou.organization_id
     AND hou.organization_id IN (181)
--     AND aia.creation_date BETWEEN TO_DATE ('01-Jan-2021') AND TO_DATE('30-Jun-2022')
     AND aia.gl_date BETWEEN TO_DATE ('01-Jan-2021') AND TO_DATE('30-Jun-2022')
     AND a.invoice_id = aia.invoice_id
ORDER BY a.invoice_id, sequence_num ASC;