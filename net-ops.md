
# subnets



# Organisation

We want to make use of CIDR to properly segment a department private networks from multi-cloud infrastructure.

This is a complex hybrid-cloud and multi-cloud environment, with an intranet, an extranet, and AWS plus Azure.




# ORG Plan

The private 10/8 CIDR space is massive, and should be more than enough to accommodate ORG private networks.

We reserve the largest segment, the 10/8 class A, for all ORG private networks, aka departmental intranets.

Now we have a number of additional and extended private ranges which we can use for exposing shared extranet.

We can also assign some to cloud providers, namely one for the primary cloud, and one for a secondary cloud.



# Networks


We want to renumber all our ORG networks to avoid collisions and CIDR squatting.

We sort out the private CIDR ranges and assign them to different network types.


# ORG wide


We want the entire ORG networks to share the 10/8 class A.

    1  ORG  
    4  super branches
    16 major divisions
    64 minor departments (our DPT OU is one)
        
    Organize those into to 16 major departments

        10/8         <-- all of ORG private-hybrid-cloud    
        10/9 = 2
        10/10 = 4
        10/11 = 8
        10/12 = 16   <-- split in 16 major divisions
        
        10/13 = 32    
        10/14 = 64    
        10/15 = 128    
        10/16 = 256  <-- split in 16 minor department (ours is one)
        

    We leave the carving up of the above organisation for competent authorities.
    
    We should end up with a single class-C, CIDR 10.x/16, where (0 <= x <= 255).

    For now, let's just choose one.
    
    
    Let our DPT OU department be on 10.10/16



# CIDR addressing


IANA / IETF define the following 3 ranges for private intranet addresses.

There are also a few ranges reserved for expansion, documentation, tests.

All other address ranges are meant for routing public internet addresses.



    CIDR sizes:


    /8      16,777,216          class A
    /10      4,194,304            1/4
    /12      1,048,576            1/16
    /14        262,144            1/64   
    /16         65,536          class B
    /18         16,384            1/4
    /20           4096            1/16
    /22           1024            1/64
    /24            256          class C
    


## Base Private CIDR

    10.0.0.0/8        10.0.0.0      -  10.255.255.255    16,777,216     private net
    172.16.0.0/12     172.16.0.0    -  172.31.255.255    1,048,576      private net
    192.168.0.0/16    192.168.0.0   -  192.168.255.255   65,536         private net

    
## Extra Private CIDR

    100.64.0.0/10     100.64.0.0    -  100.127.255.255   4,194,304      private shared NAT
    198.18.0.0/15     198.18.0.0    -  198.19.255.255    131,072        private subnet test    
    

## Test Private CIDR
    
    192.0.0.0/24      192.0.0.0     -  192.0.0.255       256            private net    
    192.0.2.0/24      192.0.2.0     -  192.0.2.255       256            test-net-1
    198.51.100.0/24   198.51.100.0  -  198.51.100.255    256            test-net-2
    203.0.113.0/24    203.0.113.0   -  203.0.113.255     256            test-net-3
    
## Reserved Experimental CIDR

    240.0.0.0/4       240.0.0.0.0   -  255.255.255.255   268,435,456    experimental-net (reserved)
    

## Cloud Private CIDR

These more or less correspond to the 3 major Cloud VPC CIDR ranges.   
    
All 3 major cloud providers (Amazon AWS, Microsoft Azure, Google GCP)

support the 3 basic Private CIDR ranges as well as the 2 extra ranges.

    Cloud basic ranges:

        10.0.0.0/8      10.0.0.0    -  10.255.255.255                    
        172.16.0.0/12   172.16.0.0  -  172.31.255.255             
        192.168.0.0/16  192.168.0.0 -  192.168.255.255          

    Cloud extra ranges:
    
        100.64/16
        198.18/15
    

In addition, we can use the unused ISP-Provider private Test network ranges.


# CIDR Allocation Strategy

The following is just an example strategy of what might make sense.




# Available CIDR blocs

What makes sense, in terms of a rational institutional allocation strategy, 

is to reserve the very largest block for the institutional intranet or WAN.

.

Now the largest block is the Reserved Experimental block on 240.0.0.0/4.

However, IEEE IETF IANA sepcifically mention that it is reserved for

future expansion, and that it may be blocked by providers and even OSes,

We shall avoid squatting this block for now, there is plenty of room.

.

Let us use the next largest block, the 10.0.0.0/8 for the on-premise WAN.

Let 10.0.0.0/8 be the ORG intranet, which is thenb subdivided by DPT OU.

Allocation will vary, for example, let our particular DPT OU be on 10.10/16.

.

Next we reserve 172.x/16 for our Primary Cloud (ie Microsoft Azure VNETs).

We also reserve 100.64/16 for our Secondary Cloud (ie Amazon AWS VPCs).

.

We keep 192.168 for various external DMZs, Remote VLANS, WIFI WLANs, etc.

We keep 198.18/15 for hybrid cloud links with other OR/ORG or EU networks.

And finally we can use the 4 small ISP test networks for internal NAT/DMZ.



    1  class A       10/8            private-intranet       (on-premise)
    
    1  class B       100.64/16       secondary-cloud        (amazon)

    16 class B       172.16/12       primary-cloud          (azure)
                     172.16.0/16
                     172.16.1/16
                     ...
                     172.16.31/16

    1 class B        192.168/16      external-dmz           (external collaborators)  

    4 class C        192.0.0/24      internal-nat           (internal DPT staff)
                     192.2.0/24      developer
                     198.51.100/24   integrators
                     203.0.113/24    administrators

    2 class B        198.18/15       proprietary-data

    16 class A       240/4           experimental-net       (reserved)


# Allocated CIDR blocs

Going into more detail, we could split 172.16/12 by project (ie application).

The following is an example of what a functional subnetting might look like.

This is purely hypothetical, but one can see a very strong network segmentation.



    CIDR networks:

    10/8            ORG private networks
    10/12           DIV major divisions (16)
    10/16           DPT minor departments (16)

    10.10/16        DPT private intranet

    100.64/16       DPT multi-cloud
    100.64.0/17     DPT azure cloud
    100.64.128/17   DPT google cloud

    172.16/12       DPT AWS private cloud (custom VPCs)
    172.16/16       vpc-1  ad       administration
    172.17/16       vpc-2  hr       human-resources
    172.18/16       vpc-3  op       operations
    172.19/16       vpc-3  da       data-science
    ..
    172.21/16       vpc-3  it       technology
    ..
    172.23/16       vpc-3  id       identity
    ..
    172.24/16       vpc-3  ap       access api
    ..
    172.25/16       vpc-3  bm       business model
    ..
    172.27/16       vpc-28 w1       webapp-1
    172.28/16       vpc-29 w2       webapp-2          
    172.29/16       vpc-30 w3       webapp-3
    172.30/16       vpc-31 w4       webapp-4
    172.31/16       vpc-0  wb       web (default VPC)

    192.168/16      DMZ (general local public DMZ)
    192.168.0/17    DPT-partner-dmz (partners, etc)
    192.168.128/17  DPT-supplier-dmz (suppliers ect)

    192.0.0/24      nat-0 admin (staff)
    192.0.2/24      nat-1 sysop (operators)
    198.51.100/24   nat-2 devel (developers)
    203.0.113/24    nat-3 stats (administrators)

    198.18/15       DPT hybrid data
    198.18./16      DPT-private-data (on-premise data)
    198.19./16      DPT-shared-data (vpn-link data)

    240/4           reserved
    

# DPT Private Intranet  (10.10/16)

And finally we can apply the same strategy to our 10/8 DPT private Intranet.

If we're going to migrate from 3/8, we should organise this subnet as well.

It makes sense to separate this by funtional domain, ie DPT directorates.

A big chunk of this will be IT and our various on-premise project spaces.

.

The following is just an example.


    10.10.0    ad    administration
    10.10.16   hr    human-resources
    10.10.32   op    operations      
    10.10.48   da    data science  
    10.10.64       
    10.10.80   it    technology
    10.10.96   
    10.10.112  id    identity
    10.10.128  
    10.10.144  ap    access api
    10.10.160  
    10.10.176  bm    business model
    10.10.192  
    10.10.208  w1    webapp-1
    10.10.224  w2    webapp-2
    10.10.224  w3    webapp-3
    10.10.240  w4    webapp-4
    
    


# Primary Cloud VPC  (172.0/16 - 172.31/16)

Recall there is a limit of VNET/VPC per account (but can ask for more).
    
    - ask for and account for 8 - some reserved for future use

    - organize by major functional product lines aka projects. 



Recall our Primary Region has 3 AZ Availability Zones (a,b,c)

    - we should create an additional  non-routable private static zone
    
    - we reserve a 4th zone-d for a dedicated network delegate-group

    - this subnet is for the static part of Elastic IPS, Gateway IPs,

    - for VPC endpoints, Lambda endpoints, dedicated NAT instances, 

    - it can also be used for local zones, internal static IPs, etc



The next is an example strategy for a large DPT project, say business model.

It would have 4 environments: DEV, INT, MNT, plus an PRD 3-zone HA Production.

Each zone would host part of Prod, plus another 2 miscellaneous environments.



Sample VPC: 

    vpc         172.x/16
    
    a               172.x.0/18          zone-a
      adm           172.x.0/20          (administrative services)
      dev           172.x.16/20         (development environment)
      a.prod        172.x.32/19         (production zone-a)
        a.prod.pub     172.x.32/20
        a.prod.prv     172.x.48/20
    
    b               172.x.64/18         zone-b
      bld           172.x.64/20         (build factory environment)
      int            172.x.80/20        (integration environment)
      b.prod          172.x.96/19       (production zone-b)
        b.prod.pub     172.x.96/20
        b.prod.prv     172.x.112/20
    
    c               172.x.128/18        zone-c
      mnt           172.x.128/20        (maintenance uat/stage environment)
      tmp           172.x.144/20        (ephemeral temp or test environment)
      c.prod          172.x.160/19      (production zone-c)
        c.prod.pub      172.x.160/20
        c.prod.prv      172.x.176/20
    
    d               172.x.192/18        zone-d  (dedicated delegate-group)
      d.adm           172.x.192/21      
      d.dev           172.x.200/21 
      d.bld           172.x.208/21 
      d.itg           172.x.216/21 
      d.mnt           172.x.224/21 
      d.tmp           172.x.232/21  
      d.prd           172.0.240/19 


    # DNS sub-domains and AD
    
    The Integration of Active Directory, Azure AD, AWS AD, Managed AD, LDAP could use some help.

    We could map subdomains between and *.DPT.aws and *.DPT.ie, *.*.DPT.aws and *.*.DPT.ie, etc.

    _TODO_  figure out the mappings, subnetting, etc.


# Appendix

## IP Addressing

    https://en.wikipedia.org/wiki/Reserved_IP_addresses

    https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing


# Amazon AWS CIDR

    https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html
    
    
## Google GCP CIDR

    https://cloud.google.com/vpc/docs/vpc#valid-ranges
    https://cloud.google.com/vpc/docs/subnets#valid-ranges
    https://cloud.google.com/vpc/docs/subnets#additional-ipv4-considerations   
    
    
## Microsoft Azure CIDR

    https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-faq



    
    
