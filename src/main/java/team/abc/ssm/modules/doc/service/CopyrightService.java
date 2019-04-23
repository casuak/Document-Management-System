package team.abc.ssm.modules.doc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.doc.dao.CopyrightMapper;
import team.abc.ssm.modules.doc.entity.Copyright;

import java.util.List;

/**
 * @author zm
 * @description
 * @data 2019/4/23
 */
@Service
public class CopyrightService {
    @Autowired
    private CopyrightMapper copyrightMapper;

    public List<Copyright> getMyCopyByPage(Author author) {
        return copyrightMapper.getCopyList(author);
    }


    public int getMyCopyAmount(String authorId) {
        return copyrightMapper.getMyCopyAmount(authorId);
    }
}
