package team.abc.ssm.modules.patent.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import javax.print.Doc;

import team.abc.ssm.modules.author.dao.AuthorMapper;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.patent.dao.DocPatentMapper;
import team.abc.ssm.modules.patent.entity.DocPatent;

import java.util.List;

@Service
public class DocPatentService{

    @Resource
    private DocPatentMapper docPatentMapper;

    @Autowired
    private AuthorMapper authorMapper;

    public int deleteByPrimaryKey(String id) {
        return docPatentMapper.deleteByPrimaryKey(id);
    }

    
    public int insert(DocPatent record) {
        return docPatentMapper.insert(record);
    }

    
    public int insertSelective(DocPatent record) {
        return docPatentMapper.insertSelective(record);
    }

    
    public DocPatent selectByPrimaryKey(String id) {
        return docPatentMapper.selectByPrimaryKey(id);
    }

    
    public int updateByPrimaryKeySelective(DocPatent record) {
        return docPatentMapper.updateByPrimaryKeySelective(record);
    }

    
    public int updateByPrimaryKey(DocPatent record) {
        return docPatentMapper.updateByPrimaryKey(record);
    }

    public List<DocPatent> selectListByPage(DocPatent patent) {
        return docPatentMapper.selectListByPage(patent);
    }

    public int selectSearchCount(DocPatent patent) {
        return docPatentMapper.selectSearchCount(patent);
    }

    /**
     * 专利初始化
     * */
    public void initialPatent(){
        //0.获取所有status是-1的专利项目
        List<DocPatent> patentList = docPatentMapper.selectAllByStatus("-1");
        //1.授权日期string -> datetime
        //2.第一作者第二作者分割
        //3.第一作者
    }

    /**
     * 从authorList中分割出第一作者和第二作者的姓名
     */
    public void authorNameDivision(List<DocPatent> patentList){
        for (int i = 0; i < patentList.size(); i++) {
            String authorListStr  = patentList.get(i).getAuthorList();
            String[] tmpAuthorArr = authorListStr.split("[, ;]");
            patentList.get(i).setFirstAuthorName(tmpAuthorArr[0]);
            patentList.get(i).setSecondAuthorName(tmpAuthorArr[1]);
        }
    }

    /**
     * 根据作者姓名去数据库中匹配相应的作者
     */
    public void authorMatch(DocPatent patent){
        String firstAuthorName = patent.getFirstAuthorName();
        String secondAuthorName = patent.getSecondAuthorName();

        List<Author> firstAuthorList = authorMapper.getAuthorsByRealname(firstAuthorName);
        List<Author> secondAuthorList = authorMapper.getAuthorsByRealname(secondAuthorName);
    }
}
