-- Function: category_get_id_by_full_code(text)

-- 删除函数
DROP FUNCTION IF exists category_get_id_by_full_code(text) ;

-- 创建函数
CREATE OR REPLACE FUNCTION category_get_id_by_full_code(full_code text)
  RETURNS integer AS
$BODY$
	/** 获取 full code 的 id
	 *	@param full_code 树节点全编码
	 */
	DECLARE
		_id INT;
		i INT;
		r record;
	BEGIN
		-- 参数为空返回空值
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
			
			-- id 为空返回空值
			if _id is null then 
				return null;
			end if;
			
      i := i + 1;
		END LOOP;
		-- 返回查询到的id
		return _id;
	END;
	$BODY$
  LANGUAGE plpgsql VOLATILE