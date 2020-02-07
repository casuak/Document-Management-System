package team.abc.ssm.modules.document.patent.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.document.authorSearch.entity.Author;
import team.abc.ssm.modules.document.patent.dao.PatentMapper;
import team.abc.ssm.modules.document.patent.entity.Patent;

import java.util.List;

/**
 * @author zm
 * @description
 * @data 2019/4/23
 */
@Service
public class PatentService {
    @Autowired
    private PatentMapper patentMapper;

    public List<Patent> getMyPatentByPage(Author author) {
        return patentMapper.getPatentList(author);
    }

    public int getMyPatentAmount(String authorId) {
        return patentMapper.getMyPatentAmount(authorId);
    }
}
