package team.abc.ssm.modules.doc.api;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @author zm
 * @description 查询论文的相关接口
 * @data 2019/3/26
 */
@Controller
@RequestMapping(value = "api/doc/search")
public class SearchApi {

    /*跳转用户文献列表页面*/
    @RequestMapping(value = "searchDocList",method = RequestMethod.GET)
    public String searchDocList(){
        System.out.println("ok");
        return "functions/doc/paperUserSearch/userPaper";
    }
}
