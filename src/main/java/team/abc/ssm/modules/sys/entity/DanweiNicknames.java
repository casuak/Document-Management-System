package team.abc.ssm.modules.sys.entity;

import team.abc.ssm.common.persistence.DataEntity;

import java.util.List;

/**
 * 导入的excel中存在单位列，存储了多个单位简称
 */
public class DanweiNicknames extends DataEntity<DanweiNicknames> {
    /**
	* 中文名
	*/
    private String name;

    // 辅助
    private List<String> nicknameList;
    private String nicknames;

    private String nickname1;

    private String nickname2;

    private String nickname3;

    private String nickname4;

    private String nickname5;

    private String nickname6;

    private String nickname7;

    private String nickname8;

    private String nickname9;

    private String nickname10;

    private String nickname11;

    private String nickname12;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNickname1() {
        return nickname1;
    }

    public void setNickname1(String nickname1) {
        this.nickname1 = nickname1;
    }

    public String getNickname2() {
        return nickname2;
    }

    public void setNickname2(String nickname2) {
        this.nickname2 = nickname2;
    }

    public String getNickname3() {
        return nickname3;
    }

    public void setNickname3(String nickname3) {
        this.nickname3 = nickname3;
    }

    public String getNickname4() {
        return nickname4;
    }

    public void setNickname4(String nickname4) {
        this.nickname4 = nickname4;
    }

    public String getNickname5() {
        return nickname5;
    }

    public void setNickname5(String nickname5) {
        this.nickname5 = nickname5;
    }

    public String getNickname6() {
        return nickname6;
    }

    public void setNickname6(String nickname6) {
        this.nickname6 = nickname6;
    }

    public String getNickname7() {
        return nickname7;
    }

    public void setNickname7(String nickname7) {
        this.nickname7 = nickname7;
    }

    public String getNickname8() {
        return nickname8;
    }

    public void setNickname8(String nickname8) {
        this.nickname8 = nickname8;
    }

    public String getNickname9() {
        return nickname9;
    }

    public void setNickname9(String nickname9) {
        this.nickname9 = nickname9;
    }

    public String getNickname10() {
        return nickname10;
    }

    public void setNickname10(String nickname10) {
        this.nickname10 = nickname10;
    }

    public String getNickname11() {
        return nickname11;
    }

    public void setNickname11(String nickname11) {
        this.nickname11 = nickname11;
    }

    public String getNickname12() {
        return nickname12;
    }

    public void setNickname12(String nickname12) {
        this.nickname12 = nickname12;
    }

    public List<String> getNicknameList() {
        return nicknameList;
    }

    public void setNicknameList(List<String> nicknameList) {
        this.nicknameList = nicknameList;
    }

    public String getNicknames() {
        return nicknames;
    }

    public void setNicknames(String nicknames) {
        this.nicknames = nicknames;
    }
}