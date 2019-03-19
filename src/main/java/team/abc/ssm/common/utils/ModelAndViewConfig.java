package team.abc.ssm.common.utils;

import org.springframework.web.servlet.ModelAndView;

/**
 * 暂时没有使用
 */
public class ModelAndViewConfig {

    public static ModelAndView setDefaultJSCSSLocation(String view){
        ModelAndView modelAndView = new ModelAndView(view);
        modelAndView.addObject("jsLocation", "/static/js/" + view + ".js");
        modelAndView.addObject("cssLocation", "/static/css/" + view + ".css");
        return modelAndView;
    }
}
