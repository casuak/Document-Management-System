package team.abc.ssm.modules.author.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.author.mapper.AuthorMapper;
import team.abc.ssm.modules.sys.entity.User;

import java.util.List;

/**
 * @author zm
 * @description
 * @data 2019/4/2
 */
@Service
public class AuthorService {

    @Autowired
    private AuthorMapper authorMapper;

    /*返回默认的作者list*/
    public List<User> getDefaultUserList(){
        return authorMapper.getDefaltAuthor();
    }

    /*根据条件返回作者list*/
    public List<User> getUserList(String roleId,String orgId,String subId,String authorName){
        String tmpName = '%'+authorName+'%';
        return authorMapper.getAuthorList(roleId, orgId, subId, tmpName);
    }
}
