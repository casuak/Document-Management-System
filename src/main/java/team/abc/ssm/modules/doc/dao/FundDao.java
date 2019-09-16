package team.abc.ssm.modules.doc.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import team.abc.ssm.modules.author.entity.SysUser;
import team.abc.ssm.modules.doc.entity.Fund;

public interface FundDao {
    void init();

    List<Fund> list(Fund fund);

    int listCount(Fund fund);

    int deleteByPrimaryKey(String id);

    int deleteFundByStatus(String status);

    List<Fund> selectAllByStatus(String status);

    int selectByStatusAndMetricNameAndProjectNameAndDelFlag(
            @Param("status") String status,
            @Param("metricName") String metricName,
            @Param("projectName") String projectName,
            @Param("delFlag") boolean delFlag);

    int updateByPrimaryKeySelective(Fund fund);

    int findUserByWorkId(String workId);

    String findUserName(String workId);

    String findPersonId(String workId);

    int updateFund(Fund fund);

    List<SysUser> findById(String id);
    List<SysUser> findByName(String name);

    int matchFund(Fund fund);

    String findMetricDict(String metric);
}
