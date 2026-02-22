# Example CLI command to create the Launch Template
aws ec2 create-launch-template \
    --launch-template-name MyFlaskTemplate \
    --version-description WebVersion1 \
    --launch-template-data '{"ImageId":"ami-xxxxxx","InstanceType":"t3.micro"}'

# Example CLI command to create the Auto Scaling Group
aws autoscaling create-auto-scaling-group \
    --auto-scaling-group-name MyFlaskASG \
    --launch-template LaunchTemplateName=MyFlaskTemplate \
    --min-size 1 --max-size 2 --desired-capacity 1