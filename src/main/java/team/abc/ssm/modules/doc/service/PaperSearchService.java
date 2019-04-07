package team.abc.ssm.modules.doc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.doc.dao.PaperSearchMapper;
import team.abc.ssm.modules.doc.entity.Paper;

import java.util.List;

/**
 * @author zm
 * @description
 * @data 2019/4/2
 */
@Service
public class PaperSearchService {

    @Autowired
    private PaperSearchMapper paperSearchMapper;

    /*条件返回指定的PaperList*/
    public List<Paper> getPaperList(String paperName, String firstAuthor, String secondAuthor, String otherAuthor, String journalNum, String storeNum, String docType, int paperPageIndex, int paperPageSize){
        List<Paper> paperList = paperSearchMapper.getPaperList(paperName,firstAuthor,secondAuthor,otherAuthor,journalNum,storeNum,docType,paperPageIndex,paperPageSize);
        return paperList;
    }
}
