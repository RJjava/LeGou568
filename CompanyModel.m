//
//  CompanyModel.m
//  GouWu568
//
//  Created by echo13 on 15/9/25.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "CompanyModel.h"

@implementation CompanyModel


- (void)setCompanyModelByDic:(NSDictionary *)dic{
    self.company_id = [dic objectForKey:@"company_id"];
    self.company_name = [dic objectForKey:@"company_name"];
    self.company_shortname = [dic objectForKey:@"company_shortname"];
    self.company_url = [dic objectForKey:@"company_url"];
    self.company_ico = [dic objectForKey:@"company_ico"];
    self.company_hits = [dic objectForKey:@"company_hits"];
    
    self.company_address = [dic objectForKey:@"company_address"];
    self.company_contact = [dic objectForKey:@"company_contact"];
    self.company_tel = [dic objectForKey:@"company_tel"];
    self.company_about = [dic objectForKey:@"company_about"];
    self.company_video = [dic objectForKey:@"company_video"];
    self.company_pro = [dic objectForKey:@"company_pro"];
    self.company_imgs_new = [dic objectForKey:@"company_imgs_new"];
    
    self.company_comment = [dic objectForKey:@"company_comment"];
    
    
}

@end
