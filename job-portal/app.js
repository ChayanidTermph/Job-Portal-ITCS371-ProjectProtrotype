const express = require("express");
const mysql = require("mysql");
const bcrypt = require("bcrypt");
const bodyParser = require("body-parser");
const path = require("path");
const fs = require('fs'); // Import the 'fs' module for file system operations

// Create the Express app
const app = express();
app.use(bodyParser.json());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files (CSS, JavaScript, etc.)
app.use(express.static(path.join(__dirname, "../front_end/html")));

// Database Connection
const db = mysql.createConnection({
  host: "127.0.0.1",
  user: "root",
  password: "ching180647",
  // database: "jobcenter",
});

// db.connect((err) => {
//     if (err) {
//         console.error('Error connecting to MySQL:', err.message);
//         return;
//     }
//     console.log('Connected to MySQL.');

//     // Read the SQL file
//     const sql = fs.readFileSync('../database/create_jobcenter_templete.sql', 'utf8');

//     // Execute the SQL file content
//     db.query(sql, (err, results) => {
//         if (err) {
//             console.error('Error executing SQL file:', err.message);
//             db.end();
//             return;
//         }
//         console.log('Database and tables created successfully.');
//         db.end();
//     });
// });

// Serve the homepage at `/`
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "../front_end/html", "homepage.html"));
});

// Register Applicant
app.post("/register/applicant", async (req, res) => {
  try {
    const { username, password, fname, lname, contact, address } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);

    db.query(
      "INSERT INTO applicant (r_username, r_password) VALUES (?, ?)",
      [username, hashedPassword],
      (err, result) => {
        if (err) return res.status(500).json({ error: err.message });

        const applicantID = result.insertId;

        db.query(
          "INSERT INTO applicant_personaldetail (a_fname, a_lname, a_contact, a_address, applicantID) VALUES (?, ?, ?, ?, ?)",
          [fname, lname, contact, address, applicantID],
          (err) => {
            if (err) return res.status(500).json({ error: err.message });
            res.status(201).json({ success: true, message: "Applicant registered successfully!" });
          }
        );
      }
    );
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Register Recruiter with Validation
app.post("/register/recruiter-full", async (req, res) => {
    const {
        citizenID,
        username,
        password,
        cardNumber,
        cardHolderName,
        expireMonth,
        expireYear,
        ccv,
        fname,
        lname,
        contact,
        address,
        companyName,
        companyWebsite,
        companyIndustry,
        companyDescription,
    } = req.body;

    try {
        // Check if either citizenID or username already exists
        db.query(
            "SELECT * FROM recruiter WHERE r_citizenID = ? OR r_username = ?",
            [citizenID, username],
            async (err, results) => {
                if (err) return res.status(500).json({ error: err.message });

                if (results.length > 0) {
                    // Check for conflicts
                    const existingCitizenID = results.find((r) => r.r_citizenID === citizenID);
                    const existingUsername = results.find((r) => r.r_username === username);

                    let errorMessage = "Registration failed: ";
                    if (existingCitizenID) errorMessage += "Citizen ID is already registered. ";
                    if (existingUsername) errorMessage += "Username is already taken.";

                    return res.status(400).json({ error: errorMessage });
                }

                // Hash the password
                const hashedPassword = await bcrypt.hash(password, 10);

                // Remove dashes from the card and contact
                const formattedCardNumber = cardNumber.replace(/-/g, "");
                const formattedContact = contact.replace(/-/g, "");

                // Start inserting data into tables
                db.query(
                    "INSERT INTO recruiter_creditcard (r_card_no, r_holderName, r_expireMonth, r_expireYear, r_ccv) VALUES (?, ?, ?, ?, ?)",
                    [formattedCardNumber, cardHolderName, expireMonth, expireYear, ccv],
                    (err, creditCardResult) => {
                        if (err) return res.status(500).json({ error: err.message });

                        db.query(
                            "INSERT INTO recruiter (r_username, r_password, r_citizenID, r_card_no) VALUES (?, ?, ?, ?)",
                            [username, hashedPassword, citizenID, formattedCardNumber],
                            (err, recruiterResult) => {
                                if (err) return res.status(500).json({ error: err.message });

                                const recruiterID = recruiterResult.insertId;

                                db.query(
                                    "INSERT INTO recruiter_personaldetail (r_fname, r_lname, r_contact, r_address, recruiterID) VALUES (?, ?, ?, ?, ?)",
                                    [fname, lname, formattedContact, address, recruiterID],
                                    (err) => {
                                        if (err) return res.status(500).json({ error: err.message });

                                        db.query(
                                            "INSERT INTO recruiter_companyprofile (r_companyname, r_companyweb, r_industry, r_comdescription, recruiterID) VALUES (?, ?, ?, ?, ?)",
                                            [companyName, companyWebsite, companyIndustry, companyDescription, recruiterID],
                                            (err) => {
                                                if (err) return res.status(500).json({ error: err.message });

                                                res.status(201).json({
                                                    success: true,
                                                    message: "Recruiter registered successfully! Redirecting to login...",
                                                });
                                            }
                                        );
                                    }
                                );
                            }
                        );
                    }
                );
            }
        );
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


// Register Applicant with Validation
app.post("/register/applicant-full", async (req, res) => {
  const {
      citizenID,
      username,
      password,
      cardNumber,
      cardHolderName,
      expireMonth,
      expireYear,
      ccv,
      fname,
      lname,
      contact,
      address,
  } = req.body;

  try {
      // Check if either citizenID or username already exists
      db.query(
          "SELECT * FROM applicant WHERE a_citizenID = ? OR a_username = ?",
          [citizenID, username],
          async (err, results) => {
              if (err) return res.status(500).json({ error: err.message });

              if (results.length > 0) {
                  // Check for conflicts
                  const existingCitizenID = results.find((r) => r.r_citizenID === citizenID);
                  const existingUsername = results.find((r) => r.r_username === username);

                  let errorMessage = "Registration failed: ";
                  if (existingCitizenID) errorMessage += "Citizen ID is already registered. ";
                  if (existingUsername) errorMessage += "Username is already taken.";

                  return res.status(400).json({ error: errorMessage });
              }

              // Hash the password
              const hashedPassword = await bcrypt.hash(password, 10);

              // Remove dashes from the card and contact
              const formattedCardNumber = cardNumber.replace(/-/g, "");
              const formattedContact = contact.replace(/-/g, "");

              // Start inserting data into tables
              db.query(
                  "INSERT INTO applicant_creditcard (a_card_no, a_holderName, a_expireMonth, a_expireYear, a_ccv) VALUES (?, ?, ?, ?, ?)",
                  [formattedCardNumber,  cardHolderName, expireMonth, expireYear, ccv],
                  (err, creditCardResult) => {
                      if (err) return res.status(500).json({ error: err.message });

                      db.query(
                          "INSERT INTO applicant (a_username, a_password, a_citizenID, a_card_no) VALUES (?, ?, ?, ?)",
                          [username, hashedPassword, citizenID, formattedCardNumber],
                          (err, recruiterResult) => {
                              if (err) return res.status(500).json({ error: err.message });

                              const recruiterID = recruiterResult.insertId;

                              db.query(
                                  "INSERT INTO applicant_personaldetail (a_fname, a_lname, a_contact, a_address, applicantID) VALUES (?, ?, ?, ?, ?)",
                                  [fname, lname, formattedContact, address, recruiterID],
                                  (err) => {
                                      if (err) return res.status(500).json({ error: err.message });
                                      res.status(201).json({
                                          success: true,
                                          message: "Applicant registered successfully! Redirecting to login...",
                                      });
                                  }
                              );
                          }
                      );
                  }
              );
          }
      );
  } catch (error) {
      res.status(500).json({ error: error.message });
  }
});

  

// Login
app.post("/login", (req, res) => {
    const { role, username, password } = req.body;
    console.log("Login Request:", { role, username, password });

    const table = role === "applicant" ? "applicant" : "recruiter";
    const idField = role === "applicant" ? "applicantID" : "recruiterID";
    
    if(role=="recruiter"){
      db.query(
        `SELECT ${idField}, r_password FROM ${table} WHERE r_username = ?`,
        [username],
        async (err, results) => {
            if (err) {
                console.error("Database Error:", err.message);
                return res.status(500).json({ error: "Internal server error" });
            }

            console.log("Query Results:", results);

            if (results.length === 0) {
                return res.status(401).json({ success: false, message: "Invalid username or password" });
            }

            const user = results[0];
            const isPasswordValid = await bcrypt.compare(password, user.r_password);

            if (!isPasswordValid) {
                return res.status(401).json({ success: false, message: "Invalid username or password" });
            }

            console.log("Login successful:", user);
            res.status(200).json({ success: true, role, id: user[idField] });
        }
      );
    }else{
      db.query(
        `SELECT ${idField}, a_password FROM ${table} WHERE a_username = ?`,
        [username],
        async (err, results) => {
            if (err) {
                console.error("Database Error:", err.message);
                return res.status(500).json({ error: "Internal server error" });
            }

            console.log("Query Results:", results);

            if (results.length === 0) {
                return res.status(401).json({ success: false, message: "Invalid username or password" });
            }

            const user = results[0];
            const isPasswordValid = await bcrypt.compare(password, user.a_password);

            if (!isPasswordValid) {
                return res.status(401).json({ success: false, message: "Invalid username or password" });
            }

            console.log("Login successful:", user);
            res.status(200).json({ success: true, role, id: user[idField] });
        }
      );
    }

    
});

// Search Jobs
app.get("/search", (req, res) => {
  const { query, category } = req.query;

  db.query(
        "SELECT * FROM job_announcement WHERE j_title LIKE ? OR category = ?",
        [`%${query}%`, category],
        (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json(results);
        }
    );
});

// Middleware for parsing JSON and form data
app.post("/recruiter/jobs", (req, res) => {
    const {
      j_title,
      j_salary,
      j_type,
      j_workexp,
      j_location,
      j_eduqualification,
      category,
      j_description,
      recruiterID,
    } = req.body;
  
    console.log("Received Data:", req.body); // Debugging log
  
    if (!recruiterID) {
      return res.status(400).json({ error: "Recruiter ID is required." });
    }
  
    db.query(
      `INSERT INTO job_announcement (j_title, j_salary, j_type, j_workexp, j_location, j_requirement, j_description, category, recruiterID)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [j_title, j_salary, j_type, j_workexp, j_location, j_eduqualification, j_description, category, recruiterID],
      (err) => {
        if (err) {
          console.error("Database Error:", err.message);
          return res.status(500).json({ error: "Failed to add job announcement." });
        }
        res.status(201).json({ success: true, message: "Job announcement created successfully!" });
      }
    );
});

app.get("/api/job-announcements", (req, res) => {
  const { query, minSalary, maxSalary, jobType, location, category } = req.query;

  let sql = "SELECT jobID, j_title, category, j_salary, j_location, j_type FROM job_announcement WHERE 1=1";
  const params = [];

  if (query) {
      sql += " AND (j_title LIKE ? OR category LIKE ?)";
      params.push(`%${query}%`, `%${query}%`);
  }
  if (minSalary) {
      sql += " AND j_salary >= ?";
      params.push(parseFloat(minSalary));
  }
  if (maxSalary) {
      sql += " AND j_salary <= ?";
      params.push(parseFloat(maxSalary));
  }
  if (jobType) {
      sql += " AND j_type = ?";
      params.push(jobType);
  }
  if (location) {
      sql += " AND j_location LIKE ?";
      params.push(`%${location}%`);
  }
  if (category) {
      sql += " AND category LIKE ?";
      params.push(`%${category}%`);
  }

  db.query(sql, params, (err, results) => {
      if (err) {
          console.error("Database Error:", err.message);
          return res.status(500).json({ error: "Failed to fetch job announcements." });
      }
      res.status(200).json(results);
  });
});


// Get Job Details by ID
app.get("/api/job-detail/:id", (req, res) => {
  const { id } = req.params;

  const sql = "SELECT * FROM job_announcement WHERE jobID = ?";
  db.query(sql, [id], (err, results) => {
    if (err) {
      console.error("Database Error:", err.message);
      return res.status(500).json({ error: "Failed to fetch job details." });
    }

    if (results.length === 0) {
      return res.status(404).json({ error: "Job not found." });
    }

    res.status(200).json(results[0]);
  });
});


// Start the server
const PORT = 5000;
app.listen(PORT, () => {
  console.log(`Server running on http://127.0.0.1:${PORT}`);
});
