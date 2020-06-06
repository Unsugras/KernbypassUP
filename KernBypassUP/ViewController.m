//
//  ViewController.m
//  KernBypassUP
//
//  Created by A2 on 2020/6/5.
//  Copyright © 2020 A2. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
;
- (IBAction)usage {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
};
-(IBAction)info{
    NSString *msg=@("这个软件主要是用于Kernbypass内核屏蔽的辅助工具，玩越狱的自然懂，没越狱的也不需要懂，官方的KernBypass是需要命令行进行操作的，需要将守护进程「changerootfs」挂起，来对一些软件进行内核级别屏蔽(和平精英:10分钟玩一次，玩一次封10分钟，再玩365天大礼包),那些什么修复黑屏补丁的，原理都是调用'changerootfs &'将守护进程挂起，怎么挂的我也没怎么看，但既然是挂起的，那总归有掉的时候，反正作者我就经常掉，还是手动来的方便。"
    "\n\n软件原理比较简单，就是通过ssh登入手机进行调用,并不是通过su权限直接调用命令,所以一定要装openssh和更改监听Port，否则会提示连接失败"
    "\n\n密码默认是alpine,但是不排除大家有可能换密码，所以在软件左上角有更改默认密码的选项。");
    

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"关于软件"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  //响应事件
                                                                  NSLog(@"action = %@", action);
                                                              }];
     
        [alert addAction:defaultAction];

        [self presentViewController:alert animated:YES completion:nil];
};
-(IBAction)Modify{
     
   UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"修改参数"
                                                                      message:@"这里是修改端口和密码的地方，如果连接失败，请按照教程修改端口或密码。\n\n因为IOS的原因非越狱APP无法访问自身的22端口,请点击使用说明查看更改端口方法"
                                                               preferredStyle:UIAlertControllerStyleAlert];
       
       UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                                 //得到文本信息
                                                                
                        [[NSUserDefaults standardUserDefaults] setObject:alert.textFields[0].text forKey:@"defaultport"];
                        [[NSUserDefaults standardUserDefaults] setObject:alert.textFields[1].text forKey:@"defaultpwd"];
//                                                                 for(UITextField *text in alert.textFields){
//
//                                                                 }
                                                             }];
       UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * action) {}];
       [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
               textField.placeholder = @"端口";
               textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultport"];
        }];
       [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
           textField.placeholder = @"密码";
           textField.secureTextEntry = YES;
           textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultpwd"];
       }];
       
       
       [alert addAction:okAction];
       [alert addAction:cancelAction];
       [self presentViewController:alert animated:YES completion:nil];
};
-(IBAction)showLabel{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
         NMSSHSession *session = [NMSSHSession connectToHost:@"127.0.0.1"
                                                        port:2222
                                                 withUsername:@"root"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (session.isConnected) {
                [session authenticateByPassword:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultpwd"]];

                if (session.isAuthorized) {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"执行成功"
                                                                          message:@"当科学家记得不要太奔放"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"俺晓得了!" style:UIAlertActionStyleDefault
                                                                             handler:^(UIAlertAction * action) {}];
                        [alert addAction:defaultAction];
                        [self presentViewController:alert animated:YES completion:nil];

                    NSError *error = nil;
                    [session.channel execute:@"changerootfs >out.file 2>&1 &" error:&error ];
                    [session.channel execute:@"disown %1" error:&error];



                }else{
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"执行失败"
                                                                          message:@"密码错误，如果你曾修改过默认密码请记得点右上角修改"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"俺晓得了!" style:UIAlertActionStyleDefault
                                                                             handler:^(UIAlertAction * action) {}];
                        [alert addAction:defaultAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    NSLog(@"Authentication Failed");
                }
            }else{
                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"执行失败"
                                                                  message:@"连接失败，请检查被手机端是否开放22端口监听以及是否安装openSSH"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"俺晓得了!" style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                NSLog(@"Connect Failed");
            }
            [session disconnect];
        });
    });
  
  
    
    
}


@end
