package team.abc.ssm.modules.doc.dao;

        import team.abc.ssm.modules.organization.domain.CommonOrganize;
        import team.abc.ssm.modules.sys.entity.User;

        import java.util.List;

public interface PaperSearchMapper {

    /*获取所有的作者身份(中文)*/
    public List<String> getAllAuthorIdentity();

    /*获取所有机构*/
    public List<CommonOrganize> getAllOrganize();

}
