require File.dirname(__FILE__) + "/../../../lib/easyopen/extension/java_token"

module EasyOpen::Extension
  describe JavaToken do
    before(:each) do
      @token = JavaToken.new
    end
    
    it "should token '   public void boot(final String[] args) throws Exception'" do
      line = "   public void boot(final String[] args) throws Exception"
      result = @token.tokenize(line)
      result[:name].should == "boot"
      result[:column].should == "   public void ".size + 1
      result[:more_info].should == line
    end

    it "should ignore token '         return getDeploymentModelFactory().newEndpoint(targetBean);'" do
      line = '         return getDeploymentModelFactory().newEndpoint(targetBean);'
      result = @token.tokenize(line)
      result.should be_nil      
    end
    
    it "should ignore token '   getVersionTag(); '" do
      line = '   getVersionTag(); '
      result = @token.tokenize(line)
      result.should be_nil
    end
    
    it "should token '   public String getVersionTag() '" do
      line = '   public String getVersionTag() '
      result = @token.tokenize(line)
      result[:name].should == "getVersionTag"
      result[:column].should == "   public String ".size + 1
      result[:more_info].should == line
    end
    
    it "should token 'public class ServiceController extends JBossNotificationBroadcasterSupport'" do
      line = 'public class ServiceController extends JBossNotificationBroadcasterSupport'
      result = @token.tokenize(line)
      result[:column].should == "public class ".size + 1
      result[:name].should == "ServiceController"
      result[:more_info].should == line      
    end
    
    it 'public @interface EndpointFeature {' do
      line = 'public @interface EndpointFeature {'
      result = @token.tokenize(line)
      result[:column].should == "public @interface ".size + 1
      result[:name].should == "EndpointFeature"
      result[:more_info].should == line
    end
  
    it "public interface Constants" do
      line = 'public interface Constants'
      result = @token.tokenize(line)
      result[:column].should == "public interface ".size + 1
      result[:name].should == "Constants"
      result[:more_info].should == line
    end

    it "should token 'public interface Constants {'" do
      line = 'public interface Constants {'
      result = @token.tokenize(line)
      result[:column].should == "public interface ".size + 1
      result[:name].should == "Constants"
      result[:more_info].should == line
    end

  end
end