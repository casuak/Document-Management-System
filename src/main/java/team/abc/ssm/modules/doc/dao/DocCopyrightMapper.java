package team.abc.ssm.modules.doc.dao;

import java.util.List;

import team.abc.ssm.modules.copyright.entity.Copyright;
import team.abc.ssm.modules.doc.entity.DocCopyright;
import tk.mybatis.mapper.common.Mapper;

public interface DocCopyrightMapper extends Mapper<Copyright> {

    int insert(DocCopyright record);

}