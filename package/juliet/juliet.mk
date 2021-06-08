################################################################################
#
# juliet-cheri
#
################################################################################

JULIET_VERSION = riscv-cheri
JULIET_SITE = https://github.com/cheri-linux/juliet-test-suite-c.git
JULIET_SITE_METHOD = git
JULIET_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_JULIET_CWE_114),y)
JULIET_CWES += CWE114
JULIET_CWE_DIRS += CWE114_Process_Control
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_121),y)
JULIET_CWES += CWE121
JULIET_CWE_DIRS += CWE121_Stack_Based_Buffer_Overflow
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_122),y)
JULIET_CWES += CWE122
JULIET_CWE_DIRS += CWE122_Heap_Based_Buffer_Overflow
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_123),y)
JULIET_CWES += CWE123
JULIET_CWE_DIRS += CWE123_Write_What_Where_Condition
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_124),y)
JULIET_CWES += CWE124
JULIET_CWE_DIRS += CWE124_Buffer_Underwrite
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_126),y)
JULIET_CWES += CWE126
JULIET_CWE_DIRS += CWE126_Buffer_Overread
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_127),y)
JULIET_CWES += CWE127
JULIET_CWE_DIRS += CWE127_Buffer_Underread
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_134),y)
JULIET_CWES += CWE134
JULIET_CWE_DIRS += CWE134_Uncontrolled_Format_String
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_15),y)
JULIET_CWES += CWE15
JULIET_CWE_DIRS += CWE15_External_Control_of_System_or_Configuration_Setting
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_176),y)
JULIET_CWES += CWE176
JULIET_CWE_DIRS += CWE176_Improper_Handling_of_Unicode_Encoding
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_188),y)
JULIET_CWES += CWE188
JULIET_CWE_DIRS += CWE188_Reliance_on_Data_Memory_Layout
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_190),y)
JULIET_CWES += CWE190
JULIET_CWE_DIRS += CWE190_Integer_Overflow
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_191),y)
JULIET_CWES += CWE191
JULIET_CWE_DIRS += CWE191_Integer_Underflow
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_194),y)
JULIET_CWES += CWE194
JULIET_CWE_DIRS += CWE194_Unexpected_Sign_Extension
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_195),y)
JULIET_CWES += CWE195
JULIET_CWE_DIRS += CWE195_Signed_to_Unsigned_Conversion_Error
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_196),y)
JULIET_CWES += CWE196
JULIET_CWE_DIRS += CWE196_Unsigned_to_Signed_Conversion_Error
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_197),y)
JULIET_CWES += CWE197
JULIET_CWE_DIRS += CWE197_Numeric_Truncation_Error
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_222),y)
JULIET_CWES += CWE222
JULIET_CWE_DIRS += CWE222_Truncation_of_Security_Relevant_Information
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_223),y)
JULIET_CWES += CWE223
JULIET_CWE_DIRS += CWE223_Omission_of_Security_Relevant_Information
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_226),y)
JULIET_CWES += CWE226
JULIET_CWE_DIRS += CWE226_Sensitive_Information_Uncleared_Before_Release
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_23),y)
JULIET_CWES += CWE23
JULIET_CWE_DIRS += CWE23_Relative_Path_Traversal
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_242),y)
JULIET_CWES += CWE242
JULIET_CWE_DIRS += CWE242_Use_of_Inherently_Dangerous_Function
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_244),y)
JULIET_CWES += CWE244
JULIET_CWE_DIRS += CWE244_Heap_Inspection
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_247),y)
JULIET_CWES += CWE247
JULIET_CWE_DIRS += CWE247_Reliance_on_DNS_Lookups_in_Security_Decision
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_252),y)
JULIET_CWES += CWE252
JULIET_CWE_DIRS += CWE252_Unchecked_Return_Value
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_253),y)
JULIET_CWES += CWE253
JULIET_CWE_DIRS += CWE253_Incorrect_Check_of_Function_Return_Value
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_256),y)
JULIET_CWES += CWE256
JULIET_CWE_DIRS += CWE256_Plaintext_Storage_of_Password
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_259),y)
JULIET_CWES += CWE259
JULIET_CWE_DIRS += CWE259_Hard_Coded_Password
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_272),y)
JULIET_CWES += CWE272
JULIET_CWE_DIRS += CWE272_Least_Privilege_Violation
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_273),y)
JULIET_CWES += CWE273
JULIET_CWE_DIRS += CWE273_Improper_Check_for_Dropped_Privileges
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_284),y)
JULIET_CWES += CWE284
JULIET_CWE_DIRS += CWE284_Improper_Access_Control
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_319),y)
JULIET_CWES += CWE319
JULIET_CWE_DIRS += CWE319_Cleartext_Tx_Sensitive_Info
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_321),y)
JULIET_CWES += CWE321
JULIET_CWE_DIRS += CWE321_Hard_Coded_Cryptographic_Key
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_325),y)
JULIET_CWES += CWE325
JULIET_CWE_DIRS += CWE325_Missing_Required_Cryptographic_Step
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_327),y)
JULIET_CWES += CWE327
JULIET_CWE_DIRS += CWE327_Use_Broken_Crypto
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_328),y)
JULIET_CWES += CWE328
JULIET_CWE_DIRS += CWE328_Reversible_One_Way_Hash
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_338),y)
JULIET_CWES += CWE338
JULIET_CWE_DIRS += CWE338_Weak_PRNG
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_364),y)
JULIET_CWES += CWE364
JULIET_CWE_DIRS += CWE364_Signal_Handler_Race_Condition
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_366),y)
JULIET_CWES += CWE366
JULIET_CWE_DIRS += CWE366_Race_Condition_Within_Thread
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_367),y)
JULIET_CWES += CWE367
JULIET_CWE_DIRS += CWE367_TOC_TOU
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_369),y)
JULIET_CWES += CWE369
JULIET_CWE_DIRS += CWE369_Divide_by_Zero
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_36),y)
JULIET_CWES += CWE36
JULIET_CWE_DIRS += CWE36_Absolute_Path_Traversal
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_377),y)
JULIET_CWES += CWE377
JULIET_CWE_DIRS += CWE377_Insecure_Temporary_File
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_390),y)
JULIET_CWES += CWE390
JULIET_CWE_DIRS += CWE390_Error_Without_Action
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_391),y)
JULIET_CWES += CWE391
JULIET_CWE_DIRS += CWE391_Unchecked_Error_Condition
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_396),y)
JULIET_CWES += CWE396
JULIET_CWE_DIRS += CWE396_Catch_Generic_Exception
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_397),y)
JULIET_CWES += CWE397
JULIET_CWE_DIRS += CWE397_Throw_Generic_Exception
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_398),y)
JULIET_CWES += CWE398
JULIET_CWE_DIRS += CWE398_Poor_Code_Quality
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_400),y)
JULIET_CWES += CWE400
JULIET_CWE_DIRS += CWE400_Resource_Exhaustion
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_401),y)
JULIET_CWES += CWE401
JULIET_CWE_DIRS += CWE401_Memory_Leak
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_404),y)
JULIET_CWES += CWE404
JULIET_CWE_DIRS += CWE404_Improper_Resource_Shutdown
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_415),y)
JULIET_CWES += CWE415
JULIET_CWE_DIRS += CWE415_Double_Free
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_416),y)
JULIET_CWES += CWE416
JULIET_CWE_DIRS += CWE416_Use_After_Free
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_426),y)
JULIET_CWES += CWE426
JULIET_CWE_DIRS += CWE426_Untrusted_Search_Path
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_427),y)
JULIET_CWES += CWE427
JULIET_CWE_DIRS += CWE427_Uncontrolled_Search_Path_Element
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_440),y)
JULIET_CWES += CWE440
JULIET_CWE_DIRS += CWE440_Expected_Behavior_Violation
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_457),y)
JULIET_CWES += CWE457
JULIET_CWE_DIRS += CWE457_Use_of_Uninitialized_Variable
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_459),y)
JULIET_CWES += CWE459
JULIET_CWE_DIRS += CWE459_Incomplete_Cleanup
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_464),y)
JULIET_CWES += CWE464
JULIET_CWE_DIRS += CWE464_Addition_of_Data_Structure_Sentinel
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_467),y)
JULIET_CWES += CWE467
JULIET_CWE_DIRS += CWE467_Use_of_sizeof_on_Pointer_Type
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_468),y)
JULIET_CWES += CWE468
JULIET_CWE_DIRS += CWE468_Incorrect_Pointer_Scaling
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_469),y)
JULIET_CWES += CWE469
JULIET_CWE_DIRS += CWE469_Use_of_Pointer_Subtraction_to_Determine_Size
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_475),y)
JULIET_CWES += CWE475
JULIET_CWE_DIRS += CWE475_Undefined_Behavior_for_Input_to_API
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_476),y)
JULIET_CWES += CWE476
JULIET_CWE_DIRS += CWE476_NULL_Pointer_Dereference
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_478),y)
JULIET_CWES += CWE478
JULIET_CWE_DIRS += CWE478_Missing_Default_Case_in_Switch
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_479),y)
JULIET_CWES += CWE479
JULIET_CWE_DIRS += CWE479_Signal_Handler_Use_of_Non_Reentrant_Function
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_480),y)
JULIET_CWES += CWE480
JULIET_CWE_DIRS += CWE480_Use_of_Incorrect_Operator
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_481),y)
JULIET_CWES += CWE481
JULIET_CWE_DIRS += CWE481_Assigning_Instead_of_Comparing
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_482),y)
JULIET_CWES += CWE482
JULIET_CWE_DIRS += CWE482_Comparing_Instead_of_Assigning
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_483),y)
JULIET_CWES += CWE483
JULIET_CWE_DIRS += CWE483_Incorrect_Block_Delimitation
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_484),y)
JULIET_CWES += CWE484
JULIET_CWE_DIRS += CWE484_Omitted_Break_Statement_in_Switch
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_500),y)
JULIET_CWES += CWE500
JULIET_CWE_DIRS += CWE500_Public_Static_Field_Not_Final
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_506),y)
JULIET_CWES += CWE506
JULIET_CWE_DIRS += CWE506_Embedded_Malicious_Code
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_510),y)
JULIET_CWES += CWE510
JULIET_CWE_DIRS += CWE510_Trapdoor
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_511),y)
JULIET_CWES += CWE511
JULIET_CWE_DIRS += CWE511_Logic_Time_Bomb
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_526),y)
JULIET_CWES += CWE526
JULIET_CWE_DIRS += CWE526_Info_Exposure_Environment_Variables
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_534),y)
JULIET_CWES += CWE534
JULIET_CWE_DIRS += CWE534_Info_Exposure_Debug_Log
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_535),y)
JULIET_CWES += CWE535
JULIET_CWE_DIRS += CWE535_Info_Exposure_Shell_Error
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_546),y)
JULIET_CWES += CWE546
JULIET_CWE_DIRS += CWE546_Suspicious_Comment
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_561),y)
JULIET_CWES += CWE561
JULIET_CWE_DIRS += CWE561_Dead_Code
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_562),y)
JULIET_CWES += CWE562
JULIET_CWE_DIRS += CWE562_Return_of_Stack_Variable_Address
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_563),y)
JULIET_CWES += CWE563
JULIET_CWE_DIRS += CWE563_Unused_Variable
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_570),y)
JULIET_CWES += CWE570
JULIET_CWE_DIRS += CWE570_Expression_Always_False
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_571),y)
JULIET_CWES += CWE571
JULIET_CWE_DIRS += CWE571_Expression_Always_True
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_587),y)
JULIET_CWES += CWE587
JULIET_CWE_DIRS += CWE587_Assignment_of_Fixed_Address_to_Pointer
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_588),y)
JULIET_CWES += CWE588
JULIET_CWE_DIRS += CWE588_Attempt_to_Access_Child_of_Non_Structure_Pointer
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_590),y)
JULIET_CWES += CWE590
JULIET_CWE_DIRS += CWE590_Free_Memory_Not_on_Heap
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_591),y)
JULIET_CWES += CWE591
JULIET_CWE_DIRS += CWE591_Sensitive_Data_Storage_in_Improperly_Locked_Memory
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_605),y)
JULIET_CWES += CWE605
JULIET_CWE_DIRS += CWE605_Multiple_Binds_Same_Port
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_606),y)
JULIET_CWES += CWE606
JULIET_CWE_DIRS += CWE606_Unchecked_Loop_Condition
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_615),y)
JULIET_CWES += CWE615
JULIET_CWE_DIRS += CWE615_Info_Exposure_by_Comment
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_617),y)
JULIET_CWES += CWE617
JULIET_CWE_DIRS += CWE617_Reachable_Assertion
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_620),y)
JULIET_CWES += CWE620
JULIET_CWE_DIRS += CWE620_Unverified_Password_Change
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_665),y)
JULIET_CWES += CWE665
JULIET_CWE_DIRS += CWE665_Improper_Initialization
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_666),y)
JULIET_CWES += CWE666
JULIET_CWE_DIRS += CWE666_Operation_on_Resource_in_Wrong_Phase_of_Lifetime
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_667),y)
JULIET_CWES += CWE667
JULIET_CWE_DIRS += CWE667_Improper_Locking
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_672),y)
JULIET_CWES += CWE672
JULIET_CWE_DIRS += CWE672_Operation_on_Resource_After_Expiration_or_Release
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_674),y)
JULIET_CWES += CWE674
JULIET_CWE_DIRS += CWE674_Uncontrolled_Recursion
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_675),y)
JULIET_CWES += CWE675
JULIET_CWE_DIRS += CWE675_Duplicate_Operations_on_Resource
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_676),y)
JULIET_CWES += CWE676
JULIET_CWE_DIRS += CWE676_Use_of_Potentially_Dangerous_Function
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_680),y)
JULIET_CWES += CWE680
JULIET_CWE_DIRS += CWE680_Integer_Overflow_to_Buffer_Overflow
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_681),y)
JULIET_CWES += CWE681
JULIET_CWE_DIRS += CWE681_Incorrect_Conversion_Between_Numeric_Types
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_685),y)
JULIET_CWES += CWE685
JULIET_CWE_DIRS += CWE685_Function_Call_With_Incorrect_Number_of_Arguments
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_688),y)
JULIET_CWES += CWE688
JULIET_CWE_DIRS += CWE688_Function_Call_With_Incorrect_Variable_or_Reference_as_Argument
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_690),y)
JULIET_CWES += CWE690
JULIET_CWE_DIRS += CWE690_NULL_Deref_From_Return
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_758),y)
JULIET_CWES += CWE758
JULIET_CWE_DIRS += CWE758_Undefined_Behavior
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_761),y)
JULIET_CWES += CWE761
JULIET_CWE_DIRS += CWE761_Free_Pointer_Not_at_Start_of_Buffer
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_762),y)
JULIET_CWES += CWE762
JULIET_CWE_DIRS += CWE762_Mismatched_Memory_Management_Routines
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_773),y)
JULIET_CWES += CWE773
JULIET_CWE_DIRS += CWE773_Missing_Reference_to_Active_File_Descriptor_or_Handle
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_775),y)
JULIET_CWES += CWE775
JULIET_CWE_DIRS += CWE775_Missing_Release_of_File_Descriptor_or_Handle
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_780),y)
JULIET_CWES += CWE780
JULIET_CWE_DIRS += CWE780_Use_of_RSA_Algorithm_Without_OAEP
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_785),y)
JULIET_CWES += CWE785
JULIET_CWE_DIRS += CWE785_Path_Manipulation_Function_Without_Max_Sized_Buffer
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_789),y)
JULIET_CWES += CWE789
JULIET_CWE_DIRS += CWE789_Uncontrolled_Mem_Alloc
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_78),y)
JULIET_CWES += CWE78
JULIET_CWE_DIRS += CWE78_OS_Command_Injection
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_832),y)
JULIET_CWES += CWE832
JULIET_CWE_DIRS += CWE832_Unlock_of_Resource_That_is_Not_Locked
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_835),y)
JULIET_CWES += CWE835
JULIET_CWE_DIRS += CWE835_Infinite_Loop
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_843),y)
JULIET_CWES += CWE843
JULIET_CWE_DIRS += CWE843_Type_Confusion
endif

ifeq ($(BR2_PACKAGE_JULIET_CWE_90),y)
JULIET_CWES += CWE90
JULIET_CWE_DIRS += CWE90_LDAP_Injection
endif

JULIET_DEPENDENCIES = host-python3 host-make

define JULIET_GENERATE
	$(foreach cwe,$(JULIET_CWE_DIRS),\
	cp $(@D)/Makefile_per_CWE $(@D)/testcases/$(cwe)/Makefile ;)
endef

JULIET_PRE_CONFIGURE_HOOKS += JULIET_GENERATE

define JULIET_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) LD=$(TARGET_LD) -C $(@D) $(JULIET_CWE_DIRS)
endef

define JULIET_INSTALL_TARGET_CMDS
	$(foreach cwe,$(JULIET_CWE_DIRS), \
	mkdir -p $(TARGET_DIR)/usr/bin/juliet/$(cwe)/bad ; \
	mkdir -p $(TARGET_DIR)/usr/bin/juliet/$(cwe)/good ; \
	$(INSTALL) -D -m 0755 $(@D)/bin/$(cwe)/bad/* $(TARGET_DIR)/usr/bin/juliet/$(cwe)/bad ; \
	$(INSTALL) -D -m 0755 $(@D)/bin/$(cwe)/good/* $(TARGET_DIR)/usr/bin/juliet/$(cwe)/good;)
endef

define JULIET_INSTALL_RUN_SCRIPT
	$(INSTALL) -D -m 0755 $(@D)/run.sh $(TARGET_DIR)/usr/bin/juliet/
	$(INSTALL) -D -m 0755 $(@D)/run-all.sh $(TARGET_DIR)/usr/bin/juliet/
endef

JULIET_POST_INSTALL_TARGET_HOOKS += JULIET_INSTALL_RUN_SCRIPT

$(eval $(generic-package))
