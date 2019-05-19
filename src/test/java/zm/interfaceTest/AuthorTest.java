package zm.interfaceTest;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.entity.Copyright;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.doc.entity.Patent;
import team.abc.ssm.modules.doc.service.CopyrightService;
import team.abc.ssm.modules.doc.service.PaperSearchService;
import team.abc.ssm.modules.doc.service.PatentService;

import java.util.List;

/**
 * @author zm
 * @description
 * @data 2019/4/23
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:spring-context.xml")
public class AuthorTest {

    private static final Logger LOG = LoggerFactory.getLogger(AuthorTest.class);
    @Autowired
    private AuthorService authorService;

    @Autowired
    private PaperSearchService paperSearchService;

    @Autowired
    private PatentService patentService;

    @Autowired
    private CopyrightService copyrightService;


    @Test
    public void test1(){
        Author authorNow = authorService.getAuthor("2293ee89284049d5b3578e90b67415d2");
        Page<Author> authorPage = new Page<>();
        authorNow.setPage(authorPage);

        System.out.println("--------------authorNow");
        System.out.println(authorNow.toString());

        /*获取集合*/
        List<Paper> myPaperList = paperSearchService.getMyPaperByPage(authorNow);
        System.out.println("--------------myPaperList");
        System.out.println(myPaperList);
        //List<Patent> myPatentList = patentService.getMyPatentByPage(authorNow);
        //List<Copyright> myCopyrightList = copyrightService.getMyCopyByPage(authorNow);

    }

    @Test
    public void batchInsert(){
        try{
            authorService.batchInsertDict();
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
