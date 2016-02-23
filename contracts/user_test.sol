import 'dapple/test.sol';
import 'user.sol';
import 'mock.sol';

contract MakerUserTester is Tester, MakerUserGeneric {
    function MakerUserTester( MakerTokenRegistry reg )
             MakerUserGeneric( reg )
    {
    }
    function doApprove(address spender, uint value, bytes32 symbol) {
        approve(spender, value, symbol);
    }
}

contract MakerUserTest is Test
                        , MakerUserGeneric(MakerTokenRegistry(0x0)) // set up in setUp
{
    uint constant million = 10**18 * 10**6;
    MakerUserTester user1;

    function setUp() {
        _maker_tokens = new MakerUserMockRegistry();
        DSEthToken(address(getToken("ETH"))).deposit.value(10000)();
        user1 = new MakerUserTester(_maker_tokens);
    }

    function testSetup() {
        assertTrue( balanceOf(this, "ETH") > 1000, "Not enough ETH" );
        assertTrue( balanceOf(this, "MKR") > 1000, "Not enough MKR" );
        assertTrue( balanceOf(this, "DAI") > 1000, "Not enough DAI" );
    }

    function testAllBasicSuccess() {
        assertEq(million, totalSupply("MKR"));
        transfer(user1, 200, "DAI");
        assertEq(200, balanceOf(user1, "DAI"));
        user1.doApprove(this, 100, "DAI");
        assertEq(100, allowance(user1, this, "DAI"));
        transferFrom(user1, this, 100, "DAI");
        assertEq(100, balanceOf(user1, "DAI"));
    }

}
