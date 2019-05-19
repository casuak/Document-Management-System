package team.abc.ssm.modules.doc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.doc.dao.PaperSearchMapper;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.doc.entity.Statistics;

import java.util.*;

/**
 * @author zm
 * @description
 * @data 2019/4/2
 */
@Service
public class PaperSearchService {
    @Autowired
    private PaperSearchMapper paperSearchMapper;

    public List<Paper> getPaperListByPage(String paperName,String FAWorkNum,String SAWorkNum,String OAWorkNum,
                                          String issn,String storeNum,String docType,Page<Paper> page){
        int pageStart = page.getPageStart();
        int pageSize = page.getPageSize();
        return paperSearchMapper.getPaperListByPage(paperName,FAWorkNum,SAWorkNum,OAWorkNum,issn,storeNum,docType,pageStart,pageSize);
    }

    /** 返回论文种类候选项*/
    public List<Map<String, String>> getPaperType(){
        List<Map<String, String>> paperTypeMap = paperSearchMapper.getPaperTypeMap();
        return paperTypeMap;
    }

    /** 条件返回指定的PaperList*/
   /* public List<Paper> getPaperList(String paperName, String firstAuthorWorkNum, String secondAuthorWorkNum,
                                    String otherAuthorWorkNum, String ISSN, String storeNum, String docType,
                                    int paperPageIndex, int paperPageSize){
        List<Paper> paperList = paperSearchMapper.getPaperList(paperName,firstAuthorWorkNum,secondAuthorWorkNum,
                otherAuthorWorkNum,ISSN,storeNum,docType,paperPageIndex,paperPageSize);

        *//*返回字典项的docType字典Map*//*
        List<Map<String,String>> docTypeList = paperSearchMapper.getPaperTypeMap();
        Map<String,String> docTypeMap = new HashMap<>();
        *//*统一添加到docTypeMap中*//*
        for (int i = 0; i < docTypeList.size(); i++) {
            Map<String,String> tmpMap = docTypeList.get(i);
            for(String key:tmpMap.keySet()){
                docTypeMap.put("key",tmpMap.get(key));
            }
        }
        System.out.println("docTypeMap: "+docTypeMap);
        *//*对paperList进行处理，把doc_type换为字典项的值*//*
        for (Paper tmpPaper : paperList){
            String typeValue = docTypeMap.get(tmpPaper.getDocType());
            tmpPaper.setDocType(typeValue);
        }
        return paperList;
    }*/

    /** 根据Id返回论文实体*/
    public Paper getPaperById(String paperId) {
        return paperSearchMapper.getPaperById(paperId);
    }

    /** 返回有效论文数量*/
    public int getPaperAmount() {
        return paperSearchMapper.getPaperNum();
    }

    /** 返回教师论文总数*/
    public int getTeacherPaperAmount() {
        return 0;
    }

    /** 学生论文总数*/
    public int getStudentPaperAmount() {
        return 0;
    }

    /** 博士后论文总数*/
    public int getPostdoctoralPaperAmount() {
        return 0;
    }

    /** 按页查询paper*/
    public List<Paper> getMyPaperByPage(Author author) {
        List<Paper> res = new ArrayList<>();
        try{
            res = paperSearchMapper.getPaperList(author);
        }catch (Exception e){
            e.printStackTrace();
        }
        return res;
    }

    public int getMyPaperAmount(String authorId) {
        return paperSearchMapper.getMyPaperAmount(authorId);
    }

    public Map<String,Statistics> getStatisticRes(String subject,String organization, Date startDate, Date endDate, String paperType,
                                      String partition) {
        Map<String,Statistics> resMap = new HashMap<>();

        Statistics paperStatistics = new Statistics();
        Statistics patentStatistics = new Statistics();
        paperStatistics.setType("论文");
        paperStatistics.setStudentDocNum(paperSearchMapper.getDocStatisticsRes(subject,organization,startDate,endDate,
                paperType,partition,"student"));
        paperStatistics.setTeacherDocNum(paperSearchMapper.getDocStatisticsRes(subject,organization,startDate,endDate,
                paperType,partition,"teacher"));
        paperStatistics.setPostdoctoralDocNum(paperSearchMapper.getDocStatisticsRes(subject,organization,startDate,endDate,
                paperType,partition,"postdoctoral"));

        System.out.println("-------------------");
        System.out.println(paperStatistics);

        /*patentStatistics.setType("专利");*/

        resMap.put("paper",paperStatistics);
        return resMap;
    }
}
