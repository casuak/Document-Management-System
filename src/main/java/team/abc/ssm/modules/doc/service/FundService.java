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
        for(Fund fund:tempList){
            if("3".equals(fund.getStatus())){
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

        if("3".equals(status)){
            List<Fund> funds = fundDao.selectAllByStatus(status);
            authorService.deleteFundCount(funds);
        }
        fundDao.deleteFundByStatus(status);
    }

    public void initFund() {
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();
        List<Fund> fundList = fundDao.selectAllByStatus("-1");

        for (Fund f : fundList) {
            //查找重复
            if (fundDao.selectByStatusAndMetricNameAndProjectNameAndDelFlag("2", f.getMetricName(), f.getProjectName(), false) != 0) {
                //重复的直接删除
                fundDao.deleteByPrimaryKey(f.getId());
                continue;
            }

            //更新信息
            f.setStatus("0");//设置为未匹配
            f.setModifyDate(dateNow);
            f.setCreateUserId(userNow.getId());

            //更新至数据库
            fundDao.updateByPrimaryKeySelective(f);
        }
    }

    public void matchUserFund() {
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();
        List<Fund> fundList = fundDao.selectAllByStatus("0");

        for (Fund f : fundList) {
            f.setMetricMatch(fundDao.findMetricDict(f.getMetricName()));

            //工号不存在或不唯一
            if (fundDao.findUserByWorkId(f.getPersonWorkId()) != 1) {
                f.setStatus("1");
                f.setModifyUserId(userNow.getId());
                f.setModifyDate(dateNow);
                fundDao.updateByPrimaryKeySelective(f);
                continue;
            }

            //与提供的姓名匹配，成功
            if (fundDao.findUserName(f.getPersonWorkId()).equals(f.getPersonName())) {
                f.setStatus("2");
                f.setPersonId(fundDao.findPersonId(f.getPersonWorkId()));
                f.setSchool(fundDao.findSchool(f.getPersonId()));
            }
            //否则失败
            else
                f.setStatus("1");

            f.setModifyUserId(userNow.getId());
            f.setModifyDate(dateNow);
            fundDao.updateByPrimaryKeySelective(f);
        }
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
        fund.setStatus("2");
        fund.setSchool(fundDao.findSchool(fund.getPersonId()));

        return fundDao.matchFund(fund) == 1;
    }

    public Map<String, Integer> doFundStatistics(StatisticCondition statisticCondition) {
        Map<String, Integer> statisticsResMap = new HashMap<>();

        String school = statisticCondition.getInstitute();
        String metric = statisticCondition.getFundType();

        Integer totalNum = fundDao.getTotal(school, metric);
        statisticsResMap.put("studentFund", 0);
        statisticsResMap.put("teacherFund", totalNum);
        statisticsResMap.put("doctorFund", 0);
        statisticsResMap.put("totalFund", totalNum);
        return statisticsResMap;
    }

    public List<String> getFundTypeList(){
        return fundDao.getFundTypeList();
    }

    public List<Fund> selectListByPageWithStatisticCondition(StatisticCondition condition){
        return fundDao.selectListByPageWithStatisticCondition(condition);
    }

    public int selectNumWithStatisticCondition(StatisticCondition condition){
        return fundDao.selectNumWithStatisticCondition(condition);
    }

    public void deleteListByIds(List<Fund> list){
        fundDao.deleteListByIds(list);
    }

    public List<Fund> selectMyPatentListByPage(Fund fund){
        return fundDao.selectMyPatentListByPage(fund);
    }

    public int getMyPatentNum(Fund fund){
        return fundDao.getMyPatentNum(fund);
    }

    public void delete(List<Fund> list){
        for (Fund f : list) {
            fundDao.deleteByPrimaryKey(f.getId());
        }
    }

    public void completeFundByStatus(){
        List<Fund> funds = fundDao.selectAllByStatus("2");
        authorService.addFundCount(funds);//todo bug

        fundDao.completeFundByStatus();
    }

    private void updateFundStatus(Fund fund){
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();
        fund.setModifyDate(dateNow);
        fund.setModifyUserId(userNow.getId());

        fundDao.updateFundStatus(fund);
    }

    public void completeFundByChoice(Fund fund){
        updateFundStatus(fund);

        List<Fund> funds = new ArrayList<>();
        funds.add(fund);
        funds=fundDao.selectListByIds(funds);
        authorService.addFundCount(funds);
    }
}
