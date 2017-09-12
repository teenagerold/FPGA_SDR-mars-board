library verilog;
use verilog.vl_types.all;
entity multiply is
    port(
        clk             : in     vl_logic;
        adc_data        : in     vl_logic_vector(9 downto 0);
        fsin            : in     vl_logic_vector(9 downto 0);
        fcos            : in     vl_logic_vector(9 downto 0);
        i_o_mixer       : out    vl_logic_vector(19 downto 0);
        q_o_mixer       : out    vl_logic_vector(19 downto 0)
    );
end multiply;
