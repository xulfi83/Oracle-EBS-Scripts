SELECT   haou.NAME bg_name, hou.NAME org_name, pha.po_header_id,pha.segment1 po_number, pah.*
    FROM po_headers_all pha,
         hr_operating_units hou,
         hr_all_organization_units haou,
         (SELECT papf.employee_name, object_id, action_date, action_code,
                 sequence_num
            FROM po_action_history pha,
                 (SELECT papf.full_name employee_name, person_id
                    FROM per_all_people_f papf
                   WHERE papf.effective_end_date =
                                     (SELECT MAX (papf1.effective_end_date)
                                        FROM per_all_people_f papf1
                                       WHERE papf.person_id = papf1.person_id)) papf
           WHERE object_type_code = 'PO' AND pha.employee_id = papf.person_id) pah
   WHERE pha.org_id = hou.organization_id
     AND hou.business_group_id = haou.organization_id
     AND pha.po_header_id = pah.object_id
ORDER BY pha.creation_date, pha.po_header_id, sequence_num ASC

