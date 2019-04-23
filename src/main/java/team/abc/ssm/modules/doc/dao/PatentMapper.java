package team.abc.ssm.modules.doc.dao;

import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.doc.entity.Patent;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;

public interface PatentMapper extends Mapper<Patent> {

    int getMyPatentAmount(String authorId);

    /*根据author的Id和page限制返回Patent集合*/
    List<Patent> getPatentList(Author author);
}