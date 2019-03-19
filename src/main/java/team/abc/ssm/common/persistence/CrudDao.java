package team.abc.ssm.common.persistence;

import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CrudDao<T> {

    /**
     * 批量增加
     *
     * @param entityList 增加的实体列表
     * @return 增加成功的数量
     */
    int insertList(List<T> entityList);

    /**
     * 单个增加
     *
     * @param entity 增加的实体对象
     * @return 增加成功的数量
     */
    int insert(T entity);

    /**
     * 指定id删除对象
     *
     * @param entity 存储id
     * @return 删除成功的数量
     */
    int deleteById(T entity);

    /**
     * 指定ids批量删除对象
     *
     * @param entityList 存储ids
     * @return 删除成功的数量
     */
    int deleteByIds(List<T> entityList);

    /**
     * 更新指定id对象的信息
     *
     * @param entity 存储id以及更新的对象信息
     * @return 更新成功的数量
     */
    int update(T entity);

    /**
     * 通过id获取对象
     *
     * @param entity 存储id
     * @return 对象
     */
    T selectById(T entity);

    /**
     * 通过ids获取对象列表
     *
     * @param entityList 存储ids
     * @return 对象列表
     */
    List<T> selectByIds(List<T> entityList);

    /**
     * @return 返回所有对象
     */
    List<T> selectAll();
}
