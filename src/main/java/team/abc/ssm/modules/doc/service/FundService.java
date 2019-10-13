package team.abc.ssm.modules.doc.service;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.utils.UserUtils;
import team.abc.ssm.modules.author.entity.SysUser;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.dao.FundDao;
import team.abc.ssm.modules.doc.entity.Fund;
import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.sys.entity.Dict;
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.common.web.FundMatchType;

@Service
public class FundService {
    @Autowired
    private FundDao fundDao;

    @Autowired
    private AuthorService authorService;

    public void init() {
        fundDao.init();
    }

    public List<Fund> list(Fund fund) {
        List<Fund> data = fundDao.list(fund);
        for (Fund f : data) {
            System.out.println(f);
        }
        return fundDao.list(fund);
    }

    public int listCount(Fund fund) {
        return fundDao.listCount(fund);
    }

    public boolean deleteByIds(List<Fund> list) {
        List<Fund> tempList = fundDao.selectListByIds(list);
        List<Fund> delList = new ArrayList<>();
        for (Fund fund : tempList) {
            if (FundMatchType.FINISHED.toString().equals(fund.getStatus())) {
                delList.add(fund);
            }
        }
        authorService.deleteFundCount(delList);

        int count = 0;
        for (Fund tmp : list) {
            if (fundDao.deleteByPrimaryKey(tmp.getId()) == 1) {
                count++;
            }
        }
        return count == list.size();
    }

    public void deleteFundByStatus(String status) {

        if (FundMatchType.FINISHED.toString().equals(status)) {
            List<Fund> funds = fundDao.selectAllByStatus(status);
            authorService.deleteFundCount(funds);
        }
        fundDao.deleteFundByStatus(status);
    }

    public void initFund() {
//        User userNow = UserUtils.getCurrentUser();
//        Date dateNow = new Date();
//        List<Fund> fundList = fundDao.selectAllByStatus(FundMatchType.UNINITIALIZED.toString());
//
//        for (Fund f : fundList) {
//            //查找重复
//            if (fundDao.selectByStatusAndMetricNameAndProjectNameAndDelFlag("2", f.getMetricName(), f.getProjectName(), false) != 0) {
//                //重复的直接删除
//                fundDao.deleteByPrimaryKey(f.getId());
//                continue;
//            }
//
//            //更新信息
//            f.setStatus("0");//设置为未匹配
//            f.setModifyDate(dateNow);
//            f.setCreateUserId(userNow.getId());
//
//            //更新至数据库
//            fundDao.updateByPrimaryKeySelective(f);
//        }

        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();
        List<Fund> fundList = fundDao.selectAllByStatus(FundMatchType.UNINITIALIZED.toString());
        List<Fund> completed = fundDao.selectAllByStatus(FundMatchType.FINISHED.toString());
        List<Fund> toDelete = new ArrayList<>();
        List<Fund> toComplete = new ArrayList<>();

        for (Fund f : fundList) {
            boolean flag = false;
            //查找重复
            for (Fund c : completed) {
                if (c.getPersonWorkId().equals(f.getPersonWorkId())
                        && c.getProjectName().equals(f.getProjectName())) {
                    //添加到删除列表
                    toDelete.add(f);
                    flag = true;
                    break;
                }
            }
            if (flag)
                continue;

            //更新信息
            f.setStatus(FundMatchType.UNMATCHED.toString());
            f.setModifyDate(dateNow);
            f.setModifyUserId(userNow.getId());

            //添加到更新列表
            toComplete.add(f);
        }

        if (!toDelete.isEmpty())
            fundDao.deleteListByIds(toDelete);
        if (!toComplete.isEmpty())
            fundDao.updateListByPrimaryKeySelective(toComplete);
    }

    public void matchUserFund() {
//        User userNow = UserUtils.getCurrentUser();
//        Date dateNow = new Date();
//        List<Fund> fundList = fundDao.selectAllByStatus(FundMatchType.UNMATCHED.toString());
//
//        for (Fund f : fundList) {
//            f.setMetricMatch(fundDao.findMetricDict(f.getMetricName()));
//
//            //工号不存在或不唯一
//            if (fundDao.findUserByWorkId(f.getPersonWorkId()) != 1) {
//                f.setStatus("1");
//                f.setModifyUserId(userNow.getId());
//                f.setModifyDate(dateNow);
//                fundDao.updateByPrimaryKeySelective(f);
//                continue;
//            }
//
//            //与提供的姓名匹配，成功
//            if (fundDao.findUserName(f.getPersonWorkId()).equals(f.getPersonName())) {
//                f.setStatus("2");
//                f.setPersonId(fundDao.findPersonId(f.getPersonWorkId()));
//                f.setSchool(fundDao.findSchool(f.getPersonId()));
//            }
//            //否则失败
//            else
//                f.setStatus("1");
//
//            f.setModifyUserId(userNow.getId());
//            f.setModifyDate(dateNow);
//            fundDao.updateByPrimaryKeySelective(f);
//        }
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();
        List<Fund> fundList = fundDao.selectAllByStatus(FundMatchType.UNMATCHED.toString());
        List<User> allUsers = fundDao.getAllUsers();
        List<Dict> allFundType = fundDao.getAllFundType();
        List<String> allUserId = new ArrayList<>();
        List<Fund> toFail = new ArrayList<>();
        List<Fund> toSuccess = new ArrayList<>();

        for (User u : allUsers) {
            allUserId.add(u.getWorkId());
            System.out.println("##########" + u.getWorkId());
        }


        for (Fund f : fundList) {
            for (Dict d : allFundType) {
                if (d.getNameCn().equals(f.getMetricName())) {
                    f.setMetricMatch(d.getId());
                    break;
                }
            }

            if (!allUserId.contains(f.getPersonWorkId())) {//工号不存在
                System.out.println(">>>>>>>>>>>>>>>>>>>>>>not exist");
                f.setStatus(FundMatchType.MATCH_FAILED.toString());
                f.setModifyUserId(userNow.getId());
                f.setModifyDate(dateNow);
                toFail.add(f);
                continue;
            }

            User user = null;

            for (User u : allUsers) {
                if (u.getWorkId().equals(f.getPersonWorkId())) {
                    user = u;
                    break;
                }
            }

            if (user == null) {
                System.out.println(">>>>>>>>>>>>>>>>>>>>>>null");
                f.setStatus(FundMatchType.MATCH_FAILED.toString());
                f.setModifyUserId(userNow.getId());
                f.setModifyDate(dateNow);
                toFail.add(f);
            } else {
                if (!user.getRealName().equals(f.getPersonName())) {//姓名不匹配
                    System.out.println(">>>>>>>>>>>>>>>>>>>>>>not match");
                    f.setStatus(FundMatchType.MATCH_FAILED.toString());
                    f.setModifyUserId(userNow.getId());
                    f.setModifyDate(dateNow);
                    toFail.add(f);
                } else {
                    f.setStatus(FundMatchType.MATCH_SUCCEEDED.toString());
                    f.setModifyUserId(userNow.getId());
                    f.setModifyDate(dateNow);
                    f.setSchool(user.getSchool());
                    f.setPersonId(user.getId());
                    toSuccess.add(f);
                }
            }
        }

        if (!toFail.isEmpty())
            fundDao.updateListByPrimaryKeySelective(toFail);
        if (!toSuccess.isEmpty())
            fundDao.updateListByPrimaryKeySelective(toSuccess);
    }

    public boolean updateFund(Fund fund) {
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();
        fund.setModifyDate(dateNow);
        fund.setModifyUserId(userNow.getId());

        return fundDao.updateFund(fund) == 1;
    }

    public List<SysUser> findById(String id) {
        if (id == null || id.equals(""))
            return new ArrayList<SysUser>();
        return fundDao.findById(id);
    }

    public List<SysUser> findByName(String name) {
        if (name == null || name.equals(""))
            return new ArrayList<SysUser>();
        return fundDao.findByName(name);
    }

    public boolean matchFund(Fund fund) {
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();
        fund.setModifyDate(dateNow);
        fund.setModifyUserId(userNow.getId());
        fund.setStatus(FundMatchType.MATCH_SUCCEEDED.toString());
        fund.setSchool(fundDao.findSchool(fund.getPersonId()));

        return fundDao.matchFund(fund) == 1;
    }

    public Map<String, Integer> doFundStatistics(StatisticCondition statisticCondition) {
        Map<String, Integer> statisticsResMap = new HashMap<>();

        String school = statisticCondition.getInstitute();
        String metric = statisticCondition.getFundType();
        int startYear = -1;
        int endYear = -1;
        //有日期筛选
        if (statisticCondition.getStartDate() != null) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(statisticCondition.getStartDate());
            startYear = calendar.get(Calendar.YEAR);
        }
        if (statisticCondition.getEndDate() != null) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(statisticCondition.getEndDate());
            endYear = calendar.get(Calendar.YEAR);
        }

        System.out.println(">>>>>out:" + startYear + " " + endYear);

        Integer totalNum = fundDao.getTotal(school, metric, startYear, endYear);
        statisticsResMap.put("studentFund", 0);
        statisticsResMap.put("teacherFund", totalNum);
        statisticsResMap.put("doctorFund", 0);
        statisticsResMap.put("totalFund", totalNum);
        return statisticsResMap;
    }

    public List<String> getFundTypeList() {
        return fundDao.getFundTypeList();
    }

    public List<Fund> selectListByPageWithStatisticCondition(StatisticCondition condition) {
        return fundDao.selectListByPageWithStatisticCondition(condition);
    }

    public int selectNumWithStatisticCondition(StatisticCondition condition) {
        return fundDao.selectNumWithStatisticCondition(condition);
    }

    public void deleteListByIds(List<Fund> list) {
        fundDao.deleteListByIds(list);
    }

    public List<Fund> selectMyPatentListByPage(Fund fund) {
        return fundDao.selectMyPatentListByPage(fund);
    }

    public int getMyPatentNum(Fund fund) {
        return fundDao.getMyPatentNum(fund);
    }

    public void delete(List<Fund> list) {
        for (Fund f : list) {
            fundDao.deleteByPrimaryKey(f.getId());
        }
    }

    public void completeFundByStatus() {
        List<Fund> funds = fundDao.selectAllByStatus(FundMatchType.MATCH_SUCCEEDED.toString());
        authorService.addFundCount(funds);

        fundDao.completeFundByStatus();
    }

    private void updateFundStatus(Fund fund) {
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();
        fund.setModifyDate(dateNow);
        fund.setModifyUserId(userNow.getId());

        fundDao.updateFundStatus(fund);
    }

    public void completeFundByChoice(Fund fund) {
        updateFundStatus(fund);

        List<Fund> funds = new ArrayList<>();
        funds.add(fund);
        funds = fundDao.selectListByIds(funds);
        authorService.addFundCount(funds);
    }
}
