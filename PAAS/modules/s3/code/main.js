import { Amplify } from 'aws-amplify';
import { get, post, del } from '@aws-amplify/api';
import { signIn, signOut, fetchAuthSession } from '@aws-amplify/auth';

const loginForm = document.getElementById('login-form');
const userInfo = document.getElementById('user-info');
const firstNameDisplay = document.getElementById('first-name');
const lastNameDisplay = document.getElementById('last-name');

let config;

// Load the configuration from S3
async function loadConfig() {
    const response = await fetch('config.json'); // Adjust the path if necessary
    config = await response.json();
}

loginForm.addEventListener('submit', async (event) => {
    event.preventDefault();

    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    // Authenticate user using AWS Cognito
    try {
        await authenticateUser(email, password);
        const data = await getBackend(); // Get the data from the backend
        displayDataAsTable(data); // Display the data as a table
        // await postBackend();
        // await delBackend();

        firstNameDisplay.textContent = "WELCOME";
        lastNameDisplay.textContent = " BACK !";
        userInfo.style.display = 'block';

    } catch (error) {
        alert('Login failed: ' + error.message);
    }
});

async function getBackend() {
    try {
        const token = await getAuthToken()
        const { body } = await get({
            apiName: "backendAPI",
            path: "/home",
            options: {
                headers: {
                    'X-Authorization': token,
                    'Content-Type': 'application/json'
                }
            }
        }).response;
        const data = await body.json();
        return data;
    }
    catch (error) {
        console.error("Error get backend: ", error);
        throw error;
    }
}

async function postBackend() {
    try {
        const token = await getAuthToken()
        const response = await post({
            apiName: "backendAPI",
            path: "/home",
            options: {
                headers: {
                    'X-Authorization': token,
                },
                body: {
                    "blabla": "TO COMPLETE"
                }
            }
        });
        console.log("Response post backend: ", response);
    }
    catch (error) {
        console.error("Error post backend: ", error);
        throw error;
    }
}


async function delBackend() {
    try {
        const token = await getAuthToken()
        const response = await del({
            apiName: "backendAPI",
            path: "/home/1",
            options: {
                headers: {
                    'X-Authorization': token,
                },
            }
        });
        console.log("Response del backend: ", response);
    }
    catch (error) {
        console.error("Error del backend: ", error);
        throw error;
    }
}

// Get JWT token
async function getAuthToken() {
    const session = await fetchAuthSession();
    return session.tokens.idToken
}

// Function to authenticate user
async function authenticateUser(username, password) {
    try {
        const user = await signIn({
            username: username,
            password: password
        })
        console.log("Signed in successfully", user);
        return user;
    } catch (error) {
        console.error("Error signing in", error);
        throw error;
    }
}

function displayDataAsTable(data) {
    if (!Array.isArray(data) || data.length === 0) {
        console.error("Invalid data format or empty data:", data);
        return;
    }

    const table = document.createElement("table");
    const headerRow = document.createElement("tr");

    // Assuming the data is an array of objects
    const headers = Object.keys(data[0]);
    headers.forEach(header => {
        const th = document.createElement("th");
        th.textContent = header;
        headerRow.appendChild(th);
    });
    table.appendChild(headerRow);

    data.forEach(item => {
        if (item && typeof item === 'object') {
            const row = document.createElement("tr");
            headers.forEach(header => {
                const td = document.createElement("td");
                td.textContent = item[header];
                row.appendChild(td);
            });
            table.appendChild(row);
        }
    });

    document.body.appendChild(table);
}

window.onload = async () => {
    await loadConfig();
    Amplify.configure({
        Auth: {
            Cognito: {
                region: config.region,
                userPoolId: config.userPoolId,
                userPoolClientId: config.userPoolWebClientId,
                email: 'true',
                password: 'true',
            }
        },
        API: {
            REST: {
                "backendAPI": {
                    endpoint: "https://" + config.paasDomainName + "/" + config.apiStageName,
                    region: config.region
                }
            }
        }
    });
};
