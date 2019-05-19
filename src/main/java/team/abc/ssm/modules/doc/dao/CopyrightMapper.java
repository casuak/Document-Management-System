package team.abc.ssm.modules.doc.dao;

import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.doc.entity.Copyright;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;

public interface CopyrightMapper extends Mapper<Copyright> {

    int getMyCopyAmount(String authorId);

    /** 根据author的Id和page限制返回Copyright集合*/
    List<Copyright> getCopyList(Author author);
}