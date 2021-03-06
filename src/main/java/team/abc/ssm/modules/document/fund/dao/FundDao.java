package team.abc.ssm.modules.document.fund.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import team.abc.ssm.modules.document.docStatistics.entity.SysUser;
import team.abc.ssm.modules.document.fund.entity.Fund;
import team.abc.ssm.modules.document.docStatistics.entity.StatisticCondition;
import team.abc.ssm.modules.sys.entity.Dict;
import team.abc.ssm.modules.sys.entity.User;

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

    @Deprecated
    int updateByPrimaryKeySelective(Fund fund);
    int updateListByPrimaryKeySelective(List<Fund> list);

    @Deprecated
    int findUserByWorkId(String workId);
    List<User> getAllUsers();

    List<Dict> getAllFundType();

    @Deprecated
    String findUserName(String workId);

    @Deprecated
    String findPersonId(String workId);

    int updateFund(Fund fund);

    List<SysUser> findById(String id);
    List<SysUser> findByName(String name);

    int matchFund(Fund fund);

    String findMetricDict(String metric);

    String findSchool(String id);

    int getTotal(String school, String matric, int startYear, int endYear);

    List<String> getFundTypeList();

    List<Fund> selectListByPageWithStatisticCondition(StatisticCondition condition);
    int selectNumWithStatisticCondition(StatisticCondition condition);

    int deleteListByIds(List<Fund> list);

    List<Fund> selectMyPatentListByPage(Fund fund);
    int getMyPatentNum(Fund fund);

    void completeFundByStatus();
    List<Fund> selectListByStatus(String status);
    List<Fund> selectListByIds(List<Fund> list);

    void updateFundStatus(Fund fund);
}
