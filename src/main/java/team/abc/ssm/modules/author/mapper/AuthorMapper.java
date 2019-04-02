package team.abc.ssm.modules.author.mapper;

import org.apache.ibatis.annotations.Param;
import team.abc.ssm.modules.sys.entity.User;

import java.util.List;

public interface AuthorMapper {

    /*返回默认的作者(角色是教师或者学生)列表*/
    public List<User> getDefaltAuthor();

    /*根据角色，机构，学科，姓名 返回作者(role是教师或者学生)信息*/
    public List<User> getAuthorList(@Param("roleId") String roleId,
                                    @Param("orgId") String orgId,
                                    @Param("subId") String subId,
                                    @Param("authorName") String authorName);
}
