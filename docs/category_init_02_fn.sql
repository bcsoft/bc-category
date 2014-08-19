-- drop function category_get_by_full_code(character varying)
CREATE OR REPLACE FUNCTION category_get_by_full_code(full_code text)
	RETURNS INT AS
	$BODY$
	/** 获取 actor 直属的组织（单位、部门或所在岗位）
	 *	@param actor_code 单位、部门、岗位或用户的编码
	 */
	DECLARE
		_id INT;
		i INT;
		r record;
	BEGIN
		-- 
		if $1 is null then 
			return null;
		end if;

		i := 0;
		FOR r IN SELECT unnest(string_to_array($1, '/')) as code from bc_dual
    LOOP
			if i = 0 then
				select c.id into _id from bc_category c where c.pid is null and c.code = r.code;
			else
				select c.id into _id from bc_category c where c.pid = _id and c.code = r.code;
			end if;
			if _id is null then 
				return null;
			end if;
      i := i + 1;
    END LOOP;
    RETURN _id;
	END;
	$BODY$ LANGUAGE plpgsql;
-- select category_get_by_full_code(null);
-- select category_get_by_full_code('TPL/JJHT/HT');