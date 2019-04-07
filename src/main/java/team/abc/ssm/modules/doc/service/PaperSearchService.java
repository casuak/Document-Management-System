package team.abc.ssm.modules.doc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.doc.dao.PaperSearchMapper;
import team.abc.ssm.modules.doc.entity.Paper;

import java.util.List;
import java.util.Map;

/**
 * @author zm
 * @description
 * @data 2019/4/2
 */
@Service
public class PaperSearchService {
    @Autowired
    private PaperSearchMapper paperSearchMapper;

    /*返回论文种类候选项*/
    public List<Map<String, String>> getPaperType(){
        List<Map<String, String>> paperTypeMap = paperSearchMapper.getPaperTypeMap();
        return paperTypeMap;
    }

    /*条件返回指定的PaperList*/
    public List<Paper> getPaperList(String paperName, String firstAuthorWorkNum, String secondAuthorWorkNum,
                                    String otherAuthorWorkNum, String journalNum, String storeNum, String docType,
                                    int paperPageIndex, int paperPageSize){
        List<Paper> paperList = paperSearchMapper.getPaperList(paperName,firstAuthorWorkNum,secondAuthorWorkNum,
                otherAuthorWorkNum,journalNum,storeNum,docType,paperPageIndex,paperPageSize);
        return paperList;
    }
}
