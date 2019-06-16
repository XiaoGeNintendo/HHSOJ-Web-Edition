package com.hhs.xgn.jee.hhsoj.db;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.util.ByteArrayDataSource;
import java.io.FileInputStream;
import java.util.Date;
import java.util.Properties;
import java.util.Random;

import com.hhs.xgn.jee.hhsoj.type.Config;
import com.hhs.xgn.jee.hhsoj.type.Contest;
import com.hhs.xgn.jee.hhsoj.type.Users;

public class MailHelper {
	private MimeMessage mimeMessage;//Mime�ʼ�����
    private Session session;//�ʼ��Ự����
    private Properties properties;//ϵͳ����
    //smtp��֤���û���������
    private String username;
    private String password;
    private Multipart multipart;//Multipart���� �ʼ����� ���� ������������ӵ������� Ȼ������MimeMessage����

    public void setup(String smtp){
    	mimeMessage=null;
    	session=null;
    	properties=null;
    	username=null;
    	password=null;
    	multipart=null;
        setSmtpHost(smtp);
        createMimeMessage();
    }

    /**
     * ����MimeMessage�ʼ�����
     * @return
     */
    public boolean createMimeMessage() {
        //��ȡ�ʼ��Ự����
        session = Session.getDefaultInstance(properties, null);
        //����Mime�ʼ�����
        mimeMessage = new MimeMessage(session);
        multipart = new MimeMultipart();
        return true;
    }

    /**
     *  �����ʼ����ͷ�����
     * @param hostName
     */
    public void setSmtpHost(String hostName) {
        if (properties==null){
            properties=System.getProperties();//���ϵͳ���Զ���
        }
        properties.put("mail.smtp.host",hostName);//����smtp����
    }

    /**
     * ����smtp�Ƿ���Ҫ��֤
     * @param need
     */
    public void setNeedAuth(boolean need){
        if (properties == null){
            properties = System.getProperties();
        }
        if (need){
            properties.put("mail.smtp.auth","true");
        }else {
            properties.put("mail.smtp.auth","false");
        }
    }

    /**
     * �����˵��û��������� 163���û������������ǰ׺
     * @param username
     * @param password
     */
    public void setNamePassword(String username,String password){
        this.username = username;
        this.password = password;
    }

    /**
     * �ʼ�����
     * @param subject
     * @return
     */
    public boolean setSubject(String subject){
        try {
            mimeMessage.setSubject(subject);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * �ʼ�����
     * @param mailBody
     * @return
     */
    public boolean setBody(String mailBody){
        BodyPart bodyPart = new MimeBodyPart();
        try {
            bodyPart.setContent(""+mailBody,"text/html;charset=utf-8");
            multipart.addBodyPart(bodyPart);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * �ʼ����ģ���ͼƬ�ģ�
     * @param mailBody
     * @param imgFile
     * @return
     */
    public boolean setBodyWithImg(String mailBody,String imgFile){
        BodyPart content = new MimeBodyPart();
        BodyPart img = new MimeBodyPart();
        try {
            multipart.addBodyPart(content);
            multipart.addBodyPart(img);

            ByteArrayDataSource byteArrayDataSource = new ByteArrayDataSource(new FileInputStream(imgFile),"application/octet-stream");
//            DataHandler imgDataHandler = new DataHandler(new FileDataSource(imgFile));
            DataHandler imgDataHandler = new DataHandler(byteArrayDataSource);
            img.setDataHandler(imgDataHandler);
//            img.setContent
            String imgFilename = imgFile.substring(imgFile.lastIndexOf("/")+1);//ͼƬ�ļ���
            //ע�⣺Content-ID������ֵһ��Ҫ����<>������ֱ��д�ļ���
            String headerValue = "<"+imgFilename+">";
            img.setHeader("Content-ID",headerValue);
            //ΪͼƬ�����ļ������е�������html��Ƕ��ͼƬҲ���ɸ���
            img.setFileName(imgFilename);
            //��html������Ҫ����ʾ�ղŵ�ͼƬ�� src�ﲻ��ֱ��дContent-ID��ֵ��Ҫ��cid:���ַ�ʽ
            mailBody+="<img src='cid:"+imgFilename+"' alt='picture' width='100px' height='100px' />,ɧ��?";
            content.setContent(""+mailBody,"text/html;charset=utf-8");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * �ʼ���Ӹ���
     * @param file
     * @return
     */
    public boolean addFileAffix(String file){
        String[] fileArray = file.split(",");

        for (int i = 0; i < fileArray.length; i++) {
            FileDataSource fileDataSource = new FileDataSource(fileArray[i]);
            try {
                BodyPart bodyPart = new MimeBodyPart();
                bodyPart.setDataHandler(new DataHandler(fileDataSource));
                bodyPart.setFileName(fileDataSource.getName());
                multipart.addBodyPart(bodyPart);
            } catch (MessagingException e) {
                e.printStackTrace();
                return false;
            }
        }
        return true;
    }

    /**
     * ����������
     * @param from
     * @return
     */
    public boolean setFrom(String from){
        try {
            mimeMessage.setFrom(new InternetAddress(from));
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * �ռ�������
     * @param to
     * @return
     */
    public boolean setTo(String to){
        if (to==null)
            return false;
        try {
            //�����ʼ��������������͵��ռ��ˣ��ֱ�to��cc��carbon copy����bcc��blind carbon copy�����ֱ����ռ��ˡ����͡�����
            mimeMessage.setRecipients(Message.RecipientType.TO,InternetAddress.parse(to));
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ���������� �ַ����ж��ŷֿ�
     * @param copyto
     * @return
     */
    public boolean setCopyTo(String copyto){
        if (copyto == null)
            return false;
        try {
            mimeMessage.setRecipients(Message.RecipientType.CC,(Address[]) InternetAddress.parse(copyto));
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ����
     * @param copyto
     * @return
     */
    public boolean sendOut(String copyto){
        try {
            //multipart����message
            mimeMessage.setContent(multipart);
            mimeMessage.saveChanges();
            Session mailSession = Session.getInstance(properties, null);
            Transport transport = mailSession.getTransport("smtp");
            transport.connect(properties.getProperty("mail.smtp.host"),username,password);
            transport.sendMessage(mimeMessage,mimeMessage.getRecipients(Message.RecipientType.TO));
            if (copyto!=null){
                transport.sendMessage(mimeMessage,mimeMessage.getRecipients(Message.RecipientType.CC));
            }
            System.out.println("Successfully sent the email");
            transport.close();
            return true;
        } catch (MessagingException e) {
            System.out.println("Failed to sent the email");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * �÷��������ϱ߶���ķ��� ѡ���Ե���� ����ʼ�����
     * ����ͨͨ��һ��һ����
     * @param smtp
     * @param from
     * @param to
     * @param subject
     * @param content
     * @param username
     * @param password
     * @return
     */
    public boolean send(String smtp,String from,String to,String subject,
                               String content,String username,String password){
        setup(smtp);
        setNeedAuth(true);//��Ҫ��֤
        if (!setSubject(subject))
            return false;
        if (!setBody(content))
            return false;
        if (!setFrom(from))
            return false;
        if (!setTo(to)){
            return false;
        }
        setNamePassword(username,password);
        if (!sendOut(null))
            return false;
        return true;
    }
    
    public String replace(String a,Users b){
    	return a.replace("{{{username}}}", ""+b.getUsername())
    			.replace("{{{code}}}", ""+b.getVerifyCode())
    			.replace("{{{email}}}",""+b.getEmail())
    			.replace("{{{passwordCode}}}", ""+b.getForgetCode());
    }
    
    public String replace(String a,Users b,Contest c){
    	return replace(a,b).replace("{{{contestName}}}", c.getInfo().getName())
    					   .replace("{{{contestStartTime}}}", new Date(c.getInfo().getStartTime())+"")
    					   .replace("{{{contestEndTime}}}", new Date(c.getInfo().getEndTime())+"")
    					   .replace("{{{length}}}", c.getInfo().getReadableLength())
    					   .replace("{{{author}}}", c.getInfo().getAuthorsHTML())
    					   .replace("{{{contestId}}}", c.getId()+"");
    }
    
    public String genNewCode(){
    	Random r=new Random();
    	String pos="0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
    	String code="";
    	for(int i=0;i<12;i++){
    		code+=pos.charAt(r.nextInt(pos.length()));
    	}
    	return code;
    }
    
    public void sendNotificationMail(Users u,Contest c){
    	
    	try{
    		System.out.println("Sending notification to "+u.getEmail()+" for "+c.getInfo().getName());
	    	Config con=new ConfigLoader().load();
	    	String content=FileHelper.readFileFull(ConfigLoader.getPath()+"/notify.html");
			boolean ok=send(con.getEmailSmtp(),
					        con.getEmailSender(),
					        u.getEmail(),
					        replace(con.getNotifySubject(),u,c),
					        replace(content,u,c),
					        con.getEmailUsername(),
					        con.getEmailPassword()
					       );
			if(ok){
				return;
			}else{
				System.out.println("Failed");
			}
    	}catch(Exception e){
    		System.out.println("Failed");
    		e.printStackTrace();
    	}
    }
    
    public String sendForgetEmail(Users u){
		System.out.println("Start sending Forget Email to "+u.getEmail());
		
		try{
			String content=FileHelper.readFileFull(ConfigLoader.getPath()+"/forget.html");
			
			u.setLastForget(System.currentTimeMillis());
			u.setForgetCode(genNewCode());
			new UserHelper().refreshUser(u);
			
			Config con=new ConfigLoader().load();
			boolean ok=send(con.getEmailSmtp(),
					        con.getEmailSender(),
					        u.getEmail(),
					        replace(con.getResetSubject(),u),
					        replace(content,u),
					        con.getEmailUsername(),
					        con.getEmailPassword()
					       );

			if(ok){
				return "Successfully sent to "+u.getEmail().substring(0, 3)+"***@***.***";
			}else{
				return "Sent failed.\nContact admin if you are really sure this is an error.";
			}
		}catch(Exception e){
			e.printStackTrace();
			return "Sent failed:"+e;
		}
	}
    
	public String sendVerifyMail(Users u){
		System.out.println("Start sending Verify Email to "+u.getEmail());
		
		try{
			String content=FileHelper.readFileFull(ConfigLoader.getPath()+"/verify.html");
			
			u.setLastVerify(System.currentTimeMillis());
			u.setVerifyCode(genNewCode());
			new UserHelper().refreshUser(u);
			
			Config con=new ConfigLoader().load();
			boolean ok=send(con.getEmailSmtp(),
					        con.getEmailSender(),
					        u.getEmail(),
					        replace(con.getEmailSubject(),u),
					        replace(content,u),
					        con.getEmailUsername(),
					        con.getEmailPassword()
					       );

			if(ok){
				return "Successfully sent to "+u.getEmail();
			}else{
				return "Sent failed.\nYou are using fake email I suppose\nOr contact admin if you are really sure this is an error.";
			}
		}catch(Exception e){
			e.printStackTrace();
			return "Sent failed:"+e;
		}
	}
}
