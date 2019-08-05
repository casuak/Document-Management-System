package team.abc.ssm.modules.paper.service;

import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import team.abc.ssm.modules.paper.entity.DocPaper;
import team.abc.ssm.modules.paper.mapper.DocPaperMapper;

import java.util.List;

@Service
public class DocPaperService{

    @Resource
    private DocPaperMapper docPaperMapper;

    
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

    public List<DocPaper> selectMyPatentListByPage(DocPaper docPaper) {
        return docPaperMapper.selectTheAuthorPapers(docPaper);
    }

    public int getMyPaperNum(String authorWorkId) {
        return docPaperMapper.selectTheAuthorPaperNum(authorWorkId);
    }
}
