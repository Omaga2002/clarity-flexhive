import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure can post new gig",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall("flexhive", "post-gig", 
        [types.utf8("Software Developer"),
         types.utf8("Need help with Clarity smart contract"),
         types.uint(1000000)],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    assertEquals(block.receipts[0].result, '(ok u0)');
  }
});

Clarinet.test({
  name: "Ensure can apply for gig",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    const wallet_2 = accounts.get("wallet_2")!;
    
    let block = chain.mineBlock([
      Tx.contractCall("flexhive", "post-gig",
        [types.utf8("Software Developer"),
         types.utf8("Need help with Clarity smart contract"),
         types.uint(1000000)],
        wallet_1.address
      ),
      Tx.contractCall("flexhive", "apply-for-gig",
        [types.uint(0),
         types.utf8("I can help with your smart contract")],
        wallet_2.address
      )
    ]);
    
    assertEquals(block.receipts.length, 2);
    assertEquals(block.receipts[1].result, '(ok true)');
  }
});
