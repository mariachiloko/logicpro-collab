
import React from 'react';
import { Amplify } from 'aws-amplify';
import awsExports from './aws-exports';
import { withAuthenticator } from '@aws-amplify/ui-react';
import '@aws-amplify/ui-react/styles.css';

import { uploadData, downloadData } from '@aws-amplify/storage';

Amplify.configure(awsExports);

function App({ signOut, user }) {
  const handleUpload = async (event) => {
    const file = event.target.files[0];
    if (!file) return;

    try {
      await uploadData({
        key: file.name,
        data: file,
      }).result;
      alert('Upload successful!');
    } catch (err) {
      console.error('Upload error:', err);
    }
  };

  const handleDownload = async () => {
    const key = prompt("Enter the file name to download:");
    if (!key) return;

    try {
      const { body } = await downloadData({ key }).result;
      const url = window.URL.createObjectURL(await body.blob());
      const link = document.createElement('a');
      link.href = url;
      link.download = key;
      link.click();
    } catch (err) {
      console.error('Download error:', err);
    }
  };

  return (
    <div style={{ padding: '20px', fontFamily: 'sans-serif' }}>
      <h1>Welcome to LogicPro Cloud</h1>
      <p>Welcome, {user?.attributes?.email || 'User'}</p>

      <div style={{ marginBottom: '10px' }}>
        <input type="file" onChange={handleUpload} />
      </div>
      <div>
        <button onClick={handleDownload}>Download File</button>
      </div>

      <div style={{ marginTop: '20px' }}>
        <button onClick={signOut}>Sign out</button>
      </div>
    </div>
  );
}

export default withAuthenticator(App);
