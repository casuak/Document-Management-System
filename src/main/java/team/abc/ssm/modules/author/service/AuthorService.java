package team.abc.ssm.modules.author.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.author.dao.AuthorMapper;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.sys.entity.User;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author zm
 * @description
 * @data 2019/4/2
 */
@Service
public class AuthorService {

    @Autowired
    private AuthorMapper authorMapper;

    public int getAuthorListCount(Author author) {
        return authorMapper.getAuthorCount(author);
    }

    /**
     * @author zm 条件查询返回相应的author，若空则返回空的arrayList
     * @date 2019/4/22
     * @param [author]
     * @return java.util.List<team.abc.ssm.modules.author.entity.Author>
     */
    public List<Author> getAuthorList(Author author) {
        List<Author> authors = authorMapper.getAuthorListByPage(author);
        if(authors.size() == 0)
            return new ArrayList<>();
        return authors;
    }

    public List<Map<String, String>> getSubListMap() {
        return authorMapper.getSubListMap();
    }

}
