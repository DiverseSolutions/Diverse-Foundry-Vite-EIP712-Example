// import { useState } from 'react'
import { ethers } from "ethers";

import logo from './logo.svg'
import './App.css'

function App() {

  async function handleSigning(){
    if (typeof window.ethereum !== 'undefined') {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      await provider.send("eth_requestAccounts", []);
      const signer = provider.getSigner()

      const domain = {
        name: 'ERC712 Example',
        version: '1',
        chainId: 80001,
        verifyingContract: '0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC'
      };

      const types = {
        set: [
          { name: 'sender', type: 'address' },
          { name: 'x', type: 'uint' },
        ],
      };

      const value = {
          sender: window.ethereum.selectedAddress,
          x: 10,
      };


      let hashData = ethers.utils._TypedDataEncoder.hash(domain,types,value)

      let signature = await signer._signTypedData(domain,types,value);
      let recoveredAddress = ethers.utils.recoverAddress(hashData,signature)

      console.log(ethers.utils.getAddress(await signer.getAddress()))
      console.log(ethers.utils.getAddress(recoveredAddress))

      console.log(ethers.utils.splitSignature(signature))
    }else{
      alert("Metamask Not Available")
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>Foundry + Vite : ERC712 Example</p>
        <p>
          <button type="button" onClick={() => handleSigning() }> Sign Data </button>
        </p>
      </header>
    </div>
  )
}

export default App
