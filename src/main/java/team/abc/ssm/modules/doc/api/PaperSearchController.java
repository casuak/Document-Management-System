package team.abc.ssm.modules.doc.api;

        import org.springframework.beans.factory.annotation.Autowired;
        import org.springframework.stereotype.Controller;
        import org.springframework.web.bind.annotation.RequestMapping;
        import org.springframework.web.bind.annotation.RequestMethod;
        import org.springframework.web.servlet.ModelAndView;
        import team.abc.ssm.modules.author.service.AuthorService;
        import team.abc.ssm.modules.sys.entity.User;

        import java.util.List;

/**
 * @author zm
 * @description 查询论文的相关接口
 * @data 2019/3/26
 */
@Controller
@RequestMapping(value = "api/doc/search")
public class PaperSearchController {

    @Autowired
    private AuthorService authorService;

    /*初始化作者查询页面*/
    @RequestMapping(value = "authorInitial", method = RequestMethod.GET)
    public ModelAndView authorInitial() {
        List<User> users = authorService.getDefaultUserList();
        System.out.println(users);

        ModelAndView modelAndView = new ModelAndView();

        modelAndView.addObject("users",users);
        modelAndView.setViewName("functions/doc/authorSearch");
        return modelAndView;
    }

    /*初始化文献管理页面*/
    @RequestMapping(value = "docInitial", method = RequestMethod.GET)
    public ModelAndView docInitial() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("functions/doc/docSearch");
        return modelAndView;
    }

    /*跳转当前用户文献列表页面*/
    @RequestMapping(value = "searchDocList",method = RequestMethod.GET)
    public String searchDocList(){
        System.out.println("ok");
        return "functions/doc/paperUserSearch/userPaper";
    }
}
