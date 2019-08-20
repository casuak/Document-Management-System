package team.abc.ssm.modules.paper.service;

import org.springframework.stereotype.Service;
import javax.annotation.Resource;

import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.paper.entity.DocPaper;
import team.abc.ssm.modules.paper.mapper.DocPaperMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DocPaperService{

    @Resource
    private DocPaperMapper docPaperMapper;

    public Map<String,Integer> doPaperStatistics(StatisticCondition statisticCondition){
        //0.论文的已完成状态是3
        statisticCondition.setStatus("3");

        int totalNum = 0;
        int studentPaperNum = 0,teacherPaperNum = 0,doctorPaperNum = 0;
        Map<String,Integer> statisticsResMap = new HashMap<>();

        List<DocPaper> paperList = docPaperMapper.getStatisticNumOfPaper(statisticCondition);
        totalNum = paperList.size();

        for (DocPaper docPaper : paperList) {
            if ("student".equals(docPaper.getFirstAuthorType())) {
                studentPaperNum++;
            } else if ("teacher".equals(docPaper.getFirstAuthorType())) {
                teacherPaperNum++;
            } else if ("doctor".equals(docPaper.getFirstAuthorType())) {
                doctorPaperNum++;
            }

            if ("student".equals(docPaper.getSecondAuthorType())) {
                studentPaperNum++;
            } else if ("teacher".equals(docPaper.getSecondAuthorType())) {
                teacherPaperNum++;
            } else if ("doctor".equals(docPaper.getSecondAuthorType())) {
                doctorPaperNum++;
            }
        }
        statisticsResMap.put("studentPaper",studentPaperNum);
        statisticsResMap.put("teacherPaper",teacherPaperNum);
        statisticsResMap.put("doctorPaper",doctorPaperNum);
        statisticsResMap.put("totalPaper",totalNum);
        return statisticsResMap;
    }


    /*-------------- autoMadeService --------------*/

    public int deleteByPrimaryKey(String id) {
        return docPaperMapper.deleteByPrimaryKey(id);
    }

    
    public int insert(DocPaper record) {
        return docPaperMapper.insert(record);
    }

    
    public int insertSelective(DocPaper record) {
        return docPaperMapper.insertSelective(record);
    }

    
    public DocPaper selectByPrimaryKey(String id) {
        return docPaperMapper.selectByPrimaryKey(id);
    }

    
    public int updateByPrimaryKeySelective(DocPaper record) {
        return docPaperMapper.updateByPrimaryKeySelective(record);
    }

    
    public int updateByPrimaryKey(DocPaper record) {
        return docPaperMapper.updateByPrimaryKey(record);
    }

    public List<DocPaper> selectAllPaperByPage(StatisticCondition statisticCondition) {
        return docPaperMapper.selectPapersWithCondition(statisticCondition);
    }
    public int selectAllPaperNum(StatisticCondition statisticCondition) {
        return docPaperMapper.selectPaperNumWithCondition(statisticCondition);
    }

    public List<DocPaper> selectMyPaperListByPage(DocPaper docPaper) {
        //获取作者的所有期刊的专利作品
        return docPaperMapper.selectTheAuthorPapers(docPaper);
    }

    public int getMyPaperNum(String authorWorkId) {
        return docPaperMapper.selectTheAuthorPaperNum(authorWorkId);
    }
}
