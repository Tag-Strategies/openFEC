-- View: public.real_efile_se_f57_vw_tmp_hc
/*
Add two columns to this view to solve issue #3708 
*/

CREATE OR REPLACE VIEW public.real_efile_se_f57_vw AS
 WITH combined AS (
         SELECT f57.repid,
            NULL AS line_num,
            f57.rel_lineno,
            f57.comid,
            f57.entity,
            f57.lname,
            f57.fname,
            f57.mname,
            f57.prefix,
            f57.suffix,
            f57.str1,
            f57.str2,
            f57.city,
            f57.state,
            f57.zip,
            f57.exp_desc,
            f57.exp_date,
            f57.amount,
            f57.so_canid,
            f57.so_can_name,
            f57.so_can_fname,
            f57.so_can_mname,
            f57.so_can_prefix,
            f57.so_can_suffix,
            f57.so_can_off,
            f57.so_can_state,
            f57.so_can_dist,
            f57.other_comid,
            f57.other_canid,
            f57.can_name,
            f57.can_off,
            f57.can_state,
            f57.can_dist,
            f57.other_name,
            f57.other_str1,
            f57.other_str2,
            f57.other_city,
            f57.other_state,
            f57.other_zip,
            f57.supop,
            NULL AS pcf_lname,
            NULL AS pcf_fname,
            NULL AS pcf_mname,
            NULL AS pcf_prefix,
            NULL AS pcf_suffix,
            NULL AS sign_date,
            NULL AS not_date,
            NULL AS expire_date,
            NULL AS not_lanme,
            NULL AS not_fname,
            NULL AS not_mname,
            NULL AS not_prefix,
            NULL AS not_suffix,
            f57.amend,
            f57.tran_id,
            NULL AS memo_code,
            NULL AS memo_text,
            NULL AS br_tran_id,
            NULL AS br_sname,
            f57.item_elect_cd,
            f57.item_elect_oth,
            f57.cat_code,
            f57.trans_code,
            f57.ytd,
            f57.imageno,
            f57.create_dt,
            NULL AS dissem_dt
           FROM real_efile.f57
        UNION ALL
         SELECT se.repid,
            se.line_num,
            se.rel_lineno,
            se.comid,
            se.entity,
            se.lname,
            se.fname,
            se.mname,
            se.prefix,
            se.suffix,
            se.str1,
            se.str2,
            se.city,
            se.state,
            se.zip,
            se.transdesc,
            se.t_date,
            se.amount,
            se.so_canid,
            se.so_can_name,
            se.so_fname,
            se.so_mname,
            se.so_prefix,
            se.so_suffix,
            se.so_can_off,
            se.so_can_state,
            se.so_can_dist,
            se.other_comid,
            se.other_canid,
            se.can_name,
            se.can_off,
            se.can_state,
            se.can_dist,
            se.other_name,
            se.other_str1,
            se.other_str2,
            se.other_city,
            se.other_state,
            se.other_zip,
            se."position",
            se.pcf_lname,
            se.pcf_fname,
            se.pcf_mname,
            se.pcf_prefix,
            se.pcf_suffix,
            se.sign_date,
            se.not_date,
            se.expire_date,
            se.not_lname,
            se.not_fname,
            se.not_mname,
            se.not_prefix,
            se.not_suffix,
            se.amend,
            se.tran_id,
            se.memo_code,
            se.memo_text,
            se.br_tran_id,
            se.br_sname,
            se.item_elect_cd,
            se.item_elect_oth,
            se.cat_code,
            se.trans_code,
            se.ytd,
            se.imageno,
            se.create_dt,
            se.dissem_dt
           FROM real_efile.se
        )
 SELECT combined.repid,
    combined.line_num,
    combined.rel_lineno,
    combined.comid,
    combined.entity,
    combined.lname,
    combined.fname,
    combined.mname,
    combined.prefix,
    combined.suffix,
    combined.str1,
    combined.str2,
    combined.city,
    combined.state,
    combined.zip,
    combined.exp_desc,
    combined.exp_date,
    combined.amount,
    combined.so_canid,
    combined.so_can_name,
    combined.so_can_fname,
    combined.so_can_mname,
    combined.so_can_prefix,
    combined.so_can_suffix,
    combined.so_can_off,
    combined.so_can_state,
    combined.so_can_dist,
    combined.other_comid,
    combined.other_canid,
    combined.can_name,
    combined.can_off,
    combined.can_state,
    combined.can_dist,
    combined.other_name,
    combined.other_str1,
    combined.other_str2,
    combined.other_city,
    combined.other_state,
    combined.other_zip,
    combined.supop,
    combined.pcf_lname,
    combined.pcf_fname,
    combined.pcf_mname,
    combined.pcf_prefix,
    combined.pcf_suffix,
    combined.sign_date,
    combined.not_date,
    combined.expire_date,
    combined.not_lanme,
    combined.not_fname,
    combined.not_mname,
    combined.not_prefix,
    combined.not_suffix,
    combined.amend,
    combined.tran_id,
    combined.memo_code,
    combined.memo_text,
    combined.br_tran_id,
    combined.br_sname,
    combined.item_elect_cd,
    combined.item_elect_oth,
    combined.cat_code,
    combined.trans_code,
    combined.ytd,
    combined.imageno,
    combined.create_dt,
    combined.dissem_dt,
    cand.cand_pty_affiliation,
    CASE
        WHEN amd.most_recent_filing IS NULL THEN NULL
        WHEN combined.repid = amd.most_recent_filing THEN true
        ELSE false
    END AS most_recent
   FROM combined
     LEFT JOIN efiling_amendment_chain_vw amd ON combined.repid = amd.repid
     LEFT JOIN disclosure.cand_valid_fec_yr cand ON combined.so_canid::text = cand.cand_id::text AND (date_part('year'::text, combined.create_dt) + (date_part('year'::text, combined.create_dt)::integer % 2)::double precision) = cand.fec_election_yr::double precision;


GRANT ALL ON TABLE public.real_efile_se_f57_vw TO fec;

GRANT SELECT ON TABLE public.real_efile_se_f57_vw TO fec_read;

-- add indexes to base table real_efile.se

CREATE INDEX idx_se_comid ON real_efile.se USING btree (comid);

CREATE INDEX idx_se_create_dt ON real_efile.se USING btree (create_dt);

CREATE INDEX idx_se_repid ON real_efile.se USING btree (repid);

CREATE INDEX idx_se_t_date ON real_efile.se USING btree (t_date);

CREATE INDEX idx_se_so_candid ON real_efile.se USING btree (so_canid);

CREATE INDEX idx_se_dissem_dt ON real_efile.se USING btree (dissem_dt);


-- add indexes to base table real_efile.f57

CREATE INDEX idx_f57_so_candid ON real_efile.se USING btree (so_canid);
