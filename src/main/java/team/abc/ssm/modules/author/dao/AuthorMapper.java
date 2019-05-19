package team.abc.ssm.modules.author.dao;

import org.apache.ibatis.annotations.Param;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.sys.entity.Dict;

import java.util.List;
import java.util.Map;

public interface AuthorMapper {

    List<Author> getAuthorListByPage(Author author);

    String getAuthorSubjectName(String authorId);

    String getAuthorOrganizeName(String authorId);

    /** 获取作者论文数*/
    int getPaperAmount(String authorId);

    /** 获取作者数目*/
    int getAuthorCount(Author author);

    Author selectByPrimaryKey(String authorId);

    /*获取专利数量*/
    //int getPatentAmount(String authorId);

    /*获取著作权数量*/
    //int getCopyrightAmount(String authorId);

    int batchInsert(@Param("list") List<Dict> majorList);

    /** 获取所有一级学科*/
    List<String> getFirstSub();

    /** 根据workId查询作者名*/
    String getNameByWorkId(String workId);
}
