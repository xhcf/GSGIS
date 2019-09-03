package cn.com.easy.util;

import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.util.Properties;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanInitializationException;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;

public class DecryptPropertyPlaceholderConfigurer extends PropertyPlaceholderConfigurer
{
    //private final String rootPath = getClass().getResource("/").getFile().toString();

    protected void processProperties(ConfigurableListableBeanFactory beanFactory, Properties props) throws BeansException
    {
        Key key = null;
		try {
			key = DesEncryptUtil.SecretKey();
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

        try
        {
            String jdbc_url = props.getProperty(PropertiesConstant.JDBC_URL);
            if(jdbc_url != null)
            {
            	//System.out.println(DesEncryptUtil.doDecrypt(key, jdbc_url));
                props.setProperty(PropertiesConstant.JDBC_URL, DesEncryptUtil.doDecrypt(key, jdbc_url));
            }

            String jdbc_username = props.getProperty(PropertiesConstant.JDBC_USERNAME);
            if(jdbc_username != null)
            {
            	//System.out.println(DesEncryptUtil.doDecrypt(key, jdbc_username));
                props.setProperty(PropertiesConstant.JDBC_USERNAME, DesEncryptUtil.doDecrypt(key, jdbc_username));
            }

            String jdbc_password = props.getProperty(PropertiesConstant.JDBC_PASSWORD);
            if(jdbc_password != null)
            {
            	//System.out.println(DesEncryptUtil.doDecrypt(key, jdbc_password));
                props.setProperty(PropertiesConstant.JDBC_PASSWORD, DesEncryptUtil.doDecrypt(key, jdbc_password));
            }

            super.processProperties(beanFactory, props);
        }
        catch (Exception e)
        {
            e.printStackTrace();
            throw new BeanInitializationException(e.getMessage());
        }
    }
}