library verilog;
use verilog.vl_types.all;
entity SDRreceiver_vlg_tst is
    generic(
        clk_period      : integer := 50;
        clk_fir_period  : integer := 10000;
        data_num        : integer := 20000;
        time_sim        : vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of clk_period : constant is 1;
    attribute mti_svvh_generic_type of clk_fir_period : constant is 1;
    attribute mti_svvh_generic_type of data_num : constant is 1;
    attribute mti_svvh_generic_type of time_sim : constant is 3;
end SDRreceiver_vlg_tst;
