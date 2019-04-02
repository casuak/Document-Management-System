//package team.abc.ssm;
//
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.ComponentScan;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.context.annotation.Import;
//import org.springframework.test.context.web.WebAppConfiguration;
//import org.springframework.web.servlet.config.annotation.EnableWebMvc;
//import springfox.bean.validators.configuration.BeanValidatorPluginsConfiguration;
//import springfox.documentation.builders.ApiInfoBuilder;
//import springfox.documentation.builders.PathSelectors;
//import springfox.documentation.builders.RequestHandlerSelectors;
//import springfox.documentation.service.ApiInfo;
//import springfox.documentation.spi.DocumentationType;
//import springfox.documentation.spring.web.plugins.Docket;
//import springfox.documentation.swagger2.annotations.EnableSwagger2;
//
///**
// * @author zm
// * @description 接口测试工具
// * @data 2019/4/2
// */
//@WebAppConfiguration
//@EnableSwagger2
//@EnableWebMvc
////@ComponentScan(basePackages = "team.abc.ssm")
//public class SwaggerConfig {
//
//    @Bean
//    public Docket createRestApi(){
//        return new Docket(DocumentationType.SWAGGER_2)
//                .select()
//                .apis(RequestHandlerSelectors.any())
//                .build()
//                .apiInfo(apiInfo());
//    }
//    private ApiInfo apiInfo(){
//        return new ApiInfoBuilder()
//                .title("XXX 项目接口文档")
//                .description("XXX 项目接口测试")
//                .version("1.0.0")
//                .termsOfServiceUrl("")
//                .license("")
//                .licenseUrl("")
//                .build();
//    }
//}
