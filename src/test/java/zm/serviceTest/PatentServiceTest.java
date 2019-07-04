package zm.serviceTest;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.mgt.DefaultSecurityManager;
import org.apache.shiro.realm.SimpleAccountRealm;
import org.apache.shiro.subject.Subject;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import team.abc.ssm.modules.author.dao.SysUserMapper;
import team.abc.ssm.modules.author.entity.SysUser;
import team.abc.ssm.modules.patent.dao.DocPatentMapper;
import team.abc.ssm.modules.patent.entity.DocPatent;
import team.abc.ssm.modules.patent.service.DocPatentService;
import zm.interfaceTest.AuthorTest;

import java.text.ParseException;
import java.util.List;

/**
 * @ClassName PatentServiceTest
 * @Description TODO
 * @Author zm
 * @Date 2019/6/24 8:32
 * @Version 1.0
 **/
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:spring-context.xml")
public class PatentServiceTest {
    private static final Logger LOG = LoggerFactory.getLogger(AuthorTest.class);

    private SimpleAccountRealm simpleAccountRealm =new SimpleAccountRealm();

    @Autowired
    private DocPatentService patentService;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private DocPatentMapper patentMapper;

    @Before
    public void addUser() {
        simpleAccountRealm.addAccount("admin","admin");
    }

    public void authenticate(){
        //1. 构建SecurityManager环境
        //1.1 创建一个默认的安全管理器
        DefaultSecurityManager defaultSecurityManager =new DefaultSecurityManager();
        //1.2 将账户域添加到安全管理器中
        defaultSecurityManager.setRealm(simpleAccountRealm);

        //2 主体提交认证请求
        //2.1 安全管理器提交到安全工具类中
        SecurityUtils.setSecurityManager(defaultSecurityManager);
        Subject subject=SecurityUtils.getSubject();

        UsernamePasswordToken token=new UsernamePasswordToken("admin","admin");
        //通过login方法和token进行认证
        subject.login(token);
        //是否认证成功的方法
        subject.isAuthenticated();
        //认证成功 输出 true
        //System.out.println( subject.isAuthenticated());
    }
    @Test
    public void getInstituteTest() {
        authenticate();
        try {
            String authors = "赵书阁,张尧,张景瑞,袁俊刚,胡照,陈余军";
            String institute = patentService.getInstitute(authors.split("[, ;]"));
            System.out.println(institute);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void initialPatentTest(){
        authenticate();
        try {
            patentService.initialPatent();
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Test
    public void authorMatchTest(){
        authenticate();
        try{
            //情况2
            //String patentId = "002f1ea2baa94268b38246751dc98dbb";

            //情况3
            //String patentId = "002f1ea2baa94268b38246751dc98dbb";

            //情况4
            //String patentId = "024b772b9b12411da8ad09d1a7192659";

            //情况5
            //String patentId = "0208256e9e0f430aaa4f37f520e79a4d";

            //情况6
            //String patentId = "01cd46db785544acb50c4c9daa8cc46a";

            //情况10
            //String patentId = "01c7d7fd42524b9c8fc67daddef555d1";

            //情况22
            //String patentId = "01f2a65ca6814a6ba94772799132ae38";

            String patentId = "e92d9294327b4790b8823783e810167a";

            DocPatent tmpPatent = patentMapper.selectByPrimaryKey(patentId);
            patentService.authorMatch(tmpPatent);
            tmpPatent = patentMapper.selectByPrimaryKey(patentId);

            System.out.println(tmpPatent);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
